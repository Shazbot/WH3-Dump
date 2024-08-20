-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	TOL - DARKNESS AND DISHARMONY
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
local playable_factions = 
	{"wh3_main_kho_exiles_of_khorne", 
	"wh3_main_nur_poxmakers_of_nurgle",
	"wh3_main_sla_seducers_of_slaanesh",
	"wh3_main_tze_oracles_of_tzeentch",
	"wh3_main_cth_the_northern_provinces",
	"wh3_main_cth_the_western_provinces",
	"wh3_main_ogr_goldtooth",
	"wh3_main_ogr_disciples_of_the_maw"}

local agents_to_ancillaries = {
	wh3_main_ogr_greasus_goldtooth = {"wh3_main_anc_weapon_sceptre_of_titans","wh3_main_anc_talisman_overtyrants_crown"},
	wh3_main_ogr_skrag_the_slaughterer = {"wh3_main_anc_enchanted_item_cauldron_of_the_great_maw"},
	wh3_main_kho_skarbrand = {"wh3_main_anc_weapon_slaughter_and_carnage"},
	wh3_main_nur_kugath = {"wh3_main_anc_weapon_necrotic_missiles"},
	wh3_main_sla_nkari = {"wh3_main_anc_weapon_witstealer_sword"},
	wh3_main_tze_kairos = {"wh3_main_anc_arcane_item_staff_of_tomorrow"},

}

----Regions that grant points
local play_area_regions = {
	"wh3_main_chaos_region_bridge_of_heaven",
	"wh3_main_chaos_region_city_of_monkeys",
	"wh3_main_chaos_region_city_of_the_shugengan",
	"wh3_main_chaos_region_dragon_gate",
	"wh3_main_chaos_region_hanyu_port",
	"wh3_main_chaos_region_jade_wind_mountain",
	"wh3_main_chaos_region_kunlan",
	"wh3_main_chaos_region_mines_of_nan_yang",
	"wh3_main_chaos_region_ming_zhu",
	"wh3_main_chaos_region_nan_gau",
	"wh3_main_chaos_region_nan_li",
	"wh3_main_chaos_region_nonchang",
	"wh3_main_chaos_region_po_mei",
	"wh3_main_chaos_region_qiang",
	"wh3_main_chaos_region_shang_wu",
	"wh3_main_chaos_region_shang_yang",
	"wh3_main_chaos_region_shi_long",
	"wh3_main_chaos_region_shrine_of_the_alchemist",
	"wh3_main_chaos_region_snake_gate",
	"wh3_main_chaos_region_tai_tzu",
	"wh3_main_chaos_region_temple_of_elemental_winds",
	"wh3_main_chaos_region_terracotta_graveyard",
	"wh3_main_chaos_region_tower_of_ashshair",
	"wh3_main_chaos_region_turtle_gate",
	"wh3_main_chaos_region_village_of_the_moon",
	"wh3_main_chaos_region_village_of_the_tigermen",
	"wh3_main_chaos_region_wei_jin",
	"wh3_main_chaos_region_weng_chang",
	"wh3_main_chaos_region_xen_wu",
	"wh3_main_chaos_region_xing_po",
	"wh3_main_chaos_region_zhanshi",
};

----Regions that have a spawned extra armies
local ai_reinforce_regions = {
	"wh3_main_chaos_region_city_of_the_shugengan",
	"wh3_main_chaos_region_kunlan",
	"wh3_main_chaos_region_xing_po",
	"wh3_main_chaos_region_zhanshi",
};

local starting_settlement_level = 4
local starting_leader_level = 5
local starting_growth_points =3
local starting_growth_points_horde = 100

local final_turn = 30
local score_goal = 40

cm:add_first_tick_callback_new(
	function()
		if cm:tol_campaign_key() == "wh3_main_tol_darkness_and_disharmony" then
			tol_shared_setup()
			
			kill_faction("wh3_dlc24_cth_the_celestial_court");
			
			-- Khorne
			region_change(
				"wh3_main_chaos_region_shi_long",
				"wh3_main_kho_exiles_of_khorne",
				{
					"wh3_main_kho_settlement_minor_3",
					"wh3_main_kho_bloodletters_1",
					"wh3_main_kho_monster_2"
				},
				starting_growth_points
			);
			teleport_character_faction_leader("wh3_main_kho_exiles_of_khorne", 1071, 552);
			teleport_character_faction_leader("wh3_main_chs_khazag", 827, 523);
			teleport_character_faction_leader("wh3_main_chs_dreaded_wo", 864, 605);
			region_change("wh3_main_chaos_region_infernius", "wh3_main_chs_gharhar");
			tol_buff("wh3_main_kho_exiles_of_khorne");
			
			-- Nurgle
			region_change(
				"wh3_main_chaos_region_shang_wu",
				"wh3_main_nur_poxmakers_of_nurgle",
				{
					"wh3_main_nur_settlement_major_"..starting_settlement_level,
				},
				starting_growth_points
			);
			
			teleport_character_faction_leader("wh3_main_nur_poxmakers_of_nurgle", 1066, 488);
			teleport_character_faction_leader("wh3_main_cth_the_jade_custodians", 1054, 504);
			region_change("wh3_main_chaos_region_the_sunken_sewers", "wh3_main_ogr_fleshgreeders");
			tol_buff("wh3_main_nur_poxmakers_of_nurgle");
			
			-- Slaanesh
			region_change(
				"wh3_main_chaos_region_hanyu_port",
				"wh3_main_sla_seducers_of_slaanesh",
				{
					"wh3_main_sla_settlement_major_"..starting_settlement_level,
					"wh3_main_sla_marauders_2",
					"wh3_main_sla_cav_2"
				},
				starting_growth_points
			);
			
			teleport_character_faction_leader("wh3_main_sla_seducers_of_slaanesh", 1011, 430);
			region_change("wh3_main_chaos_region_the_palace_of_ruin", "wh3_main_kho_crimson_skull");
			tol_buff("wh3_main_sla_seducers_of_slaanesh");
			
			-- Tzeentch
			region_change(
				"wh3_main_chaos_region_po_mei",
				"wh3_main_tze_oracles_of_tzeentch",
				{
					"wh3_main_tze_settlement_major_"..starting_settlement_level,
					"wh3_main_tze_horror_barracks_2",
					"wh3_main_tze_monster_barracks_2"
				},
				starting_growth_points
			);
			
			teleport_character_faction_leader("wh3_main_tze_oracles_of_tzeentch", 930, 597);
			teleport_character_faction_leader("wh3_main_cth_imperial_wardens", 949, 554);
			region_change("wh3_main_chaos_region_the_volary", "wh3_main_kho_karneths_sons");
			tol_buff("wh3_main_tze_oracles_of_tzeentch");
			
			-- Northern Provinces
			region_change(
				"wh3_main_chaos_region_nan_gau",
				"wh3_main_cth_the_northern_provinces",
				{
					"wh3_main_cth_settlement_major_"..starting_settlement_level,
					"wh3_main_cth_jade_barracks_2",
					"wh3_main_cth_gunners_2"
				},
				starting_growth_points
			);
			
			tol_buff("wh3_main_cth_the_northern_provinces");
			
			-- Western Provinces
			region_change(
				"wh3_main_chaos_region_shang_yang",
				"wh3_main_cth_the_western_provinces",
				{
					"wh3_main_cth_settlement_major_"..starting_settlement_level,
					"wh3_main_cth_jade_barracks_2",
					"wh3_main_cth_cavalry_2"
				},
				starting_growth_points
			);
			
			teleport_character_faction_leader("wh3_main_cth_the_western_provinces", 961, 464);
			teleport_character_faction_leader("wh3_main_cth_dissenter_lords_of_jinshen", 976, 492);
			tol_buff("wh3_main_cth_the_western_provinces");
			
			-- Goldtooth
			teleport_character_faction_leader("wh3_main_ogr_goldtooth", 957, 529);
			region_change("wh3_main_chaos_region_great_hall_of_greasus", "wh3_main_ogr_crossed_clubs");
			tol_buff("wh3_main_ogr_goldtooth");

			region_change(
				"wh3_main_chaos_region_weng_chang",
				"wh3_main_ogr_goldtooth",
				{
					"wh3_main_ogr_settlement_minor_3",
					"wh3_main_ogr_barracks_3",
					"wh3_main_ogr_defence_minor_3",
				},
				starting_growth_points
			);
			
			cm:create_force_with_general(
				"wh3_main_ogr_goldtooth",
				"wh3_main_ogr_inf_gnoblars_0,wh3_main_ogr_inf_gnoblars_0,wh3_main_ogr_inf_ogres_0,wh3_main_ogr_inf_ogres_0,wh3_main_ogr_inf_ogres_1,wh3_main_ogr_inf_ironguts_0,wh3_main_ogr_inf_ironguts_0,wh3_main_ogr_inf_ironguts_0,wh3_main_ogr_inf_ironguts_0,wh3_main_ogr_inf_leadbelchers_0,wh3_main_ogr_inf_leadbelchers_0",
				"wh3_main_chaos_region_great_hall_of_greasus",
				956,
				536,
				"general",
				"wh3_main_ogr_tyrant_camp",
				"",
				"",
				"",
				"",
				false,
				function(cqi)
					local mf_interface = cm:get_character_by_cqi(cqi):military_force()
					cm:force_character_force_into_stance(cm:char_lookup_str(cqi), "MILITARY_FORCE_ACTIVE_STANCE_TYPE_FIXED_CAMP")
					cm:add_growth_points_to_horde(mf_interface, starting_growth_points_horde)
					cm:add_building_to_force(mf_interface:command_queue_index(), 
						{"wh3_main_ogr_camp_town_centre_"..starting_settlement_level,
						"wh3_main_ogr_camp_defence_upkeep_3",
						"wh3_main_ogr_camp_heavy_cav_1"
						}
					)
				end
			);
			
			-- Skrag
			teleport_character_faction_leader("wh3_main_ogr_disciples_of_the_maw", 1014, 522);
			region_change("wh3_main_chaos_region_gristle_valley", "wh_main_dwf_karak_ziflin");

			region_change(
				"wh3_main_chaos_region_tai_tzu",
				"wh3_main_ogr_disciples_of_the_maw",
				{
					"wh3_main_ogr_settlement_minor_3",
					"wh3_main_ogr_cav_2",
					"wh3_main_ogr_defence_minor_3",
				},
				starting_growth_points
			);

			teleport_character_faction_leader("wh2_main_skv_clan_eshin", 992, 455);

			tol_buff("wh3_main_ogr_disciples_of_the_maw");
			
			cm:create_force_with_general(
				"wh3_main_ogr_disciples_of_the_maw",
				"wh3_main_ogr_inf_gnoblars_0,wh3_main_ogr_inf_gnoblars_0,wh3_main_ogr_inf_ogres_0,wh3_main_ogr_inf_ogres_0,wh3_main_ogr_inf_ogres_1,wh3_main_ogr_mon_gorgers_0, wh3_main_ogr_mon_gorgers_0,wh3_main_ogr_mon_gorgers_0,wh3_main_ogr_mon_gorgers_0,wh3_main_ogr_cav_crushers_1,wh3_main_ogr_cav_crushers_1",
				"wh3_main_chaos_region_gristle_valley",
				1009,
				534,
				"general",
				"wh3_main_ogr_tyrant_camp",
				"",
				"",
				"",
				"",
				false,
				function(cqi)
					local mf_interface = cm:get_character_by_cqi(cqi):military_force()
					cm:force_character_force_into_stance(cm:char_lookup_str(cqi), "MILITARY_FORCE_ACTIVE_STANCE_TYPE_FIXED_CAMP")
					cm:add_growth_points_to_horde(mf_interface, starting_growth_points_horde)
					cm:add_building_to_force(
						mf_interface:command_queue_index(),
						{"wh3_main_ogr_camp_town_centre_"..starting_settlement_level,
						"wh3_main_ogr_camp_defence_replenishment_3",
						"wh3_main_ogr_camp_cav_2"
						}
					)					
				end
			);
			
			local human_factions = cm:get_human_factions();
			
			cm:callback(
				function()
					cm:position_camera_at_primary_military_force(cm:get_local_faction_name(true));
					cm:reset_shroud();
					add_starting_corruption();
					for i = 1, #human_factions do
						for j = 1, #play_area_regions do
							cm:make_region_visible_in_shroud(human_factions[i], play_area_regions[j])
						end
					end
				end,
				0.5
			);
			
			for i = 1, #human_factions do
				local mm = mission_manager:new(human_factions[i], "wh3_main_mp_victory_tol");
				mm:add_new_objective("SCRIPTED");
				mm:add_condition("script_key time_of_legends_victory_condition_" .. human_factions[i]);
				mm:add_condition("override_text mission_text_text_mis_activity_time_of_legends");
				mm:add_payload("text_display dummy_wh3_main_survival_forge_of_souls");
				mm:add_payload("game_victory");
				mm:set_victory_type("wh3_main_victory_type_mp_tol");
				mm:set_show_mission(true);
				mm:trigger();
				
				--Scores: Scripted Variables
				cm:set_script_state("ToL_score_" .. human_factions[i], 0);
			end;

			cm:set_script_state("ToL_score_to_win", score_goal);
			
			--Skip AI factions
			local all_factions = cm:model():world():faction_list();
			for i = 0, all_factions:num_items()-1 do
				local faction = all_factions:item_at(i);
				if faction:is_human() == false then
					cm:set_skip_faction_turn(faction, true);
				end
			end;
			
			--Disable Generated Dilemmas
			cm:toggle_dilemma_generation(false);
			
			--Change owner 
			for i = 1, #ai_reinforce_regions do
				local settlement = cm:get_region(ai_reinforce_regions[i]):settlement();
				cm:create_force(
					"wh3_main_cth_celestial_loyalists",
					"wh3_main_cth_inf_peasant_archers_0,wh3_main_cth_inf_peasant_archers_0,wh3_main_cth_inf_peasant_spearmen_1,wh3_main_cth_inf_peasant_spearmen_1,wh3_main_cth_inf_jade_warriors_1,wh3_main_cth_inf_jade_warriors_1,wh3_main_cth_inf_jade_warriors_0,wh3_main_cth_inf_jade_warriors_0,wh3_main_cth_inf_iron_hail_gunners_0,wh3_main_cth_inf_iron_hail_gunners_0,wh3_main_cth_cav_jade_lancers_0",
					ai_reinforce_regions[i],
					settlement:logical_position_x()+2,
					settlement:logical_position_y(),
					false,
					function(cqi)
						cm:cai_disable_movement_for_character(cm:char_lookup_str(cqi));
						cm:apply_effect_bundle_to_characters_force("wh_main_bundle_military_upkeep_free_force", cqi, 0);
					end
					);
				region_change(
					ai_reinforce_regions[i],
					"wh3_main_cth_celestial_loyalists",
					nil,
					nil
				);
			end;
			
		end;
	end
);

cm:add_post_first_tick_callback(
	function()
		if cm:tol_campaign_key() == "wh3_main_tol_darkness_and_disharmony" and cm:is_new_game() then

			for i= 1, #playable_factions do
				tol_effect_bundle(playable_factions[i])
				local faction_leader = cm:get_faction(playable_factions[i]):faction_leader()
				local leader_lookup = cm:char_lookup_str(faction_leader)

				cm:add_agent_experience(leader_lookup, starting_leader_level, true)

				local ancillaries = agents_to_ancillaries[faction_leader:character_subtype_key()]

				if ancillaries then 
					for i = 1, #ancillaries do
						cm:force_add_ancillary(faction_leader, ancillaries[i], true, true);
					end
				end
			end
		end

	end
);

function tol_effect_bundle(faction_key)
	local faction = cm:get_faction(faction_key);
	if faction:has_effect_bundle("wh3_main_time_of_legends_capital_buffs") then
		cm:remove_effect_bundle("wh3_main_time_of_legends_capital_buffs", faction_key);
	end;
	cm:apply_effect_bundle("wh3_main_time_of_legends_capital_buffs", faction_key, 0);
end;
	
--------------------------
---Victory points---------
--------------------------


cm:add_first_tick_callback(
	function()
		if cm:tol_campaign_key() == "wh3_main_tol_darkness_and_disharmony" then
			tol_listeners_data();
			update_victory_points(false)
		end;
	end
);

--Victory Region Data and Listeners

function tol_listeners_data()

	out.design("ToL Victory Conditions Loaded");
	
	core:add_listener(
		"ToL_VP_calculate_round_start",
		"WorldStartRound",
		true,
		function(context)
			apply_region_bundles()

			if not cm:is_new_game() then
				local scores = update_victory_points(true);
				
				local winners, high_score, low_score = get_highest_and_lowest_score(scores)

				if high_score >= score_goal or cm:turn_number() >= final_turn then
					if #winners <= 1 then
						grant_victory(winners[1])
					end
				end
			end
		end,
		true
	);

	core:add_listener(
		"ToL_VP_recalculate_pending_scores",
		"RegionFactionChangeEvent",
		true,
		function(context)
			local human_factions = cm:get_human_factions();
			
			for i = 1, #human_factions do
				local faction = human_factions[i];
				calculate_pending_victory_points(faction)
			end;

			apply_region_bundles()
		end,
		true
	);
	
	core:add_listener(
		"conquest_victory",
		"BattleCompleted",
		true,
		function(context)
			local human_factions = cm:get_human_factions();
			local alive_factions = {};
			
			for i = 1, #human_factions do
				local faction = cm:get_faction(human_factions[i]);
				if is_faction(faction) then
					if faction:is_dead() == false then
						table.insert(alive_factions,faction:name());
					end
				end
			end;
			
			if #alive_factions == 1 then
				out.design("Grant victory to: "..alive_factions[1])
				grant_victory(alive_factions[1])
			end;
		end,
		true
	);
	
	core:add_listener(
		"ToL_visible_regions",
		"FactionTurnStart",
		function(context)
			return context:faction():is_human()
		end,
		function(context)
			for i=1, #play_area_regions do
				cm:make_region_visible_in_shroud(context:faction():name(), play_area_regions[i])
			end
		end,
		true
	);
	
	core:add_listener(
		"reset_ai_turn",
		"FactionEncountersOtherFaction",
		function(context)
			return context:faction():is_human();
		end,
		function(context)
			cm:set_skip_faction_turn(context:other_faction(), false);
		end,
		true
	);

end;




--Call at the start of a turn
--Outputs score in debug text
function update_victory_points(apply_pending)
	--Calculate all scores
	local scores = {}
	local human_factions = cm:get_human_factions()
	
	for i = 1, #human_factions do
		local faction = human_factions[i]
		
		if not cm:get_faction(faction):is_idle_human() then
			local pending_score = calculate_pending_victory_points(faction)
			local score = cm:get_saved_value("ToL_score_" .. faction) or 0
			
			out.design("Updating VPs for: " .. faction)
			if apply_pending then
				score = score + pending_score
			end

			scores[faction] = score
			cm:set_saved_value("ToL_score_" .. faction, score)
			cm:set_script_state("ToL_score_" .. faction, score)
		end
	end
	
	return(scores)
end


function calculate_pending_victory_points(faction_key)
	local region_list = cm:get_faction(faction_key):region_list()
	local pending_vp = 0

	for k, region in model_pairs(region_list) do
		pending_vp = pending_vp + cm:get_regions_bonus_value(region, "tol_bonus_vp")
	end

	cm:set_script_state("ToL_pending_score_" .. faction_key, pending_vp);

	return pending_vp
end
--
function grant_victory(winner_faction_key)
	local human_players = cm:get_human_factions()
	for i = 1, #human_players do
		if human_players[i] == winner_faction_key then
			cm:complete_scripted_mission_objective(
				winner_faction_key,
				"wh3_main_mp_victory_tol",
				"time_of_legends_victory_condition_" .. winner_faction_key,
				true
			);
		end
	end
	
	for i = 1, #human_players do
		if human_players[i] ~= winner_faction_key then
			cm:complete_scripted_mission_objective(
				human_players[i],
				"wh3_main_mp_victory_tol",
				"time_of_legends_victory_condition_" .. human_players[i],
				false
			);
		end
	end
end;


function get_highest_and_lowest_score(scores)
	local high_score = 0
	local lowest_score = 999
	local winners = {}
	out.design("get_highest_score called");
	
	for k, v in pairs(scores) do
		out.design("Player scores: "..k.." have "..tostring(v).." VPs")
		out.design(scores[k])
		if scores[k] == high_score then
			table.insert(winners, k);
		elseif scores[k] > high_score then
			out.design("New high score")
			high_score = scores[k];
			
			winners={};
			table.insert(winners, k);
		end
		if scores[k]<lowest_score then
			out.design("New low score")
			lowest_score = scores[k];
		end
	end
	
	return winners,high_score, lowest_score
end


function apply_region_bundles()

	for i = 1, #play_area_regions do
		cm:apply_effect_bundle_to_region("wh3_main_effect_tol_bonus_victory_points", play_area_regions[i], 0)
	end

	update_victory_points(false)
	
end


function tol_buff(faction_key)
	
	cm:treasury_mod(faction_key, 10000);
	
	if faction_key == "wh3_main_kho_exiles_of_khorne" then
		cm:faction_add_pooled_resource("wh3_main_kho_exiles_of_khorne", "wh3_main_kho_skulls", "events", 5000)
	end;
	
	if faction_key == "wh3_main_nur_poxmakers_of_nurgle" then
		--add mercs
		local merc_payload = cm:create_payload();
		
		merc_payload:add_mercenary_to_faction_pool("wh3_main_nur_cav_plague_drones_0", 2);
		merc_payload:add_mercenary_to_faction_pool("wh3_main_nur_inf_forsaken_0", 5);
		merc_payload:add_mercenary_to_faction_pool("wh3_main_nur_inf_nurglings_0", 8);
		merc_payload:add_mercenary_to_faction_pool("wh3_main_nur_inf_plaguebearers_0", 8);
		merc_payload:add_mercenary_to_faction_pool("wh3_main_nur_inf_plaguebearers_1", 4);
		merc_payload:add_mercenary_to_faction_pool("wh3_main_nur_mon_beast_of_nurgle_0", 4);
		merc_payload:add_mercenary_to_faction_pool("wh3_main_nur_mon_plague_toads_0", 6);
		
		cm:apply_payload(merc_payload, cm:get_faction("wh3_main_nur_poxmakers_of_nurgle"))

		cm:faction_add_pooled_resource("wh3_main_nur_poxmakers_of_nurgle", "wh3_main_nur_infections", "incubated_captives", 100)
	end


	if faction_key == "wh3_main_tze_oracles_of_tzeentch" then
		cm:faction_add_pooled_resource("wh3_main_tze_oracles_of_tzeentch", "wh3_main_tze_grimoires", "events", 300)
	end

	if faction_key == "wh3_main_sla_seducers_of_slaanesh" then
		cm:faction_add_pooled_resource("wh3_main_sla_seducers_of_slaanesh", "wh3_main_sla_devotees", "events", 500)
	end
end;

