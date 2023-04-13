local regions_to_test = {
	"wh3_main_chaos_region_kislev",
	"wh3_main_chaos_region_erengrad",
	"wh3_main_chaos_region_praag"
};

function setup_boris()
	local human_factions = cm:get_human_factions()
	local kislev_human = false;
	
	-- don't run this in tol
	if cm:tol_campaign_key() == "wh3_main_tol_something_rotten_in_kislev" then
		return false;
	end;
	
	-- check if Boris is human, or we have a human Kislev faction
	for i = 1, #human_factions do
		local current_human_faction = human_factions[i];
		
		if current_human_faction == "wh3_main_ksl_ursun_revivalists" then
			-- ensure the intro movie is unlocked!
			if not cm:is_multiplayer() then
				core:svr_save_registry_bool("ksl_intro_bor", true);
			end;
			
			return false;
		end;
		
		if cm:get_faction(current_human_faction):culture() == "wh3_main_ksl_kislev" then
			kislev_human = true;
		end;
	end;
	
	if kislev_human then
		if not cm:get_saved_value("boris_mission_issued") then
			core:add_listener(
				"check_kislev_region_ownership",
				"FactionTurnStart",
				function(context)
					local faction = context:faction();
					
					if faction:is_human() and faction:culture() == "wh3_main_ksl_kislev" then
						for i = 1, #regions_to_test do
							if cm:get_region(regions_to_test[i]):owning_faction() ~= faction then
								cm:set_saved_value("boris_unlock_counter", 0);
								return false;
							end;
						end;
						
						local counter = cm:get_saved_value("boris_unlock_counter") or 0;
						
						if counter >= 9 then
							return true;
						else
							cm:set_saved_value("boris_unlock_counter", counter + 1);
						end;
					end;
				end,
				function(context)
					cm:set_saved_value("boris_mission_issued", true);
					
					local faction_name = context:faction():name();
					local advice = "wh3_main_camp_quest_kostaltyn_boris_unlock_001";
					local mission = "wh3_main_qb_ksl_kostaltyn_boris_unlock";
					
					if faction_name == "wh3_main_ksl_the_ice_court" then
						advice = "wh3_main_camp_quest_katarin_boris_unlock_001";
						mission = "wh3_main_qb_ksl_katarin_boris_unlock";
					end;
					
					if cm:is_multiplayer() then
						cm:trigger_mission(faction_name, mission, true);
					else
						cm:trigger_transient_intervention(
							"boris_marker_intervention",
							function(intervention)
								intervention:scroll_camera_for_intervention(
									nil,
									273,
									156,
									advice,
									nil,
									nil,
									nil,
									function()
										cm:trigger_mission(faction_name, mission, true);
									end
								);
							end
						);
					end;
				end,
				false
			);
		end;
		
		if not cm:get_saved_value("boris_unlocked") then
			core:add_listener(
				"boris_quest_succeeded",
				"MissionSucceeded",
				function(context)
					local mission = context:mission():mission_record_key();
					
					return mission == "wh3_main_qb_ksl_katarin_boris_unlock" or mission == "wh3_main_qb_ksl_kostaltyn_boris_unlock";
				end,
				function(context)
					local faction = context:faction();
					local faction_name = faction:name();
					
					award_achievement_to_faction(faction_name, "WH3_ACHIEVEMENT_BORIS_UNLOCK");
					
					core:svr_save_registry_bool("ksl_intro_bor", true);
					
					local boris_dilemma = cm:create_dilemma_builder("wh3_main_dilemma_boris_unlock");
					
					local kislev = cm:get_region(regions_to_test[1]);
					if kislev:owning_faction() == faction and not kislev:garrison_residence():is_under_siege() then
						local boris_dilemma_first = cm:create_payload();
						boris_dilemma_first:text_display("dummy_wh3_main_dilemma_boris_unlock_first");
						boris_dilemma:add_choice_payload("FIRST", boris_dilemma_first);
					end;
					
					local erengrad = cm:get_region(regions_to_test[2]);
					if erengrad:owning_faction() == faction and not erengrad:garrison_residence():is_under_siege() then
						local boris_dilemma_second = cm:create_payload();
						boris_dilemma_second:text_display("dummy_wh3_main_dilemma_boris_unlock_second");
						boris_dilemma:add_choice_payload("SECOND", boris_dilemma_second);
					end;
					
					local praag = cm:get_region(regions_to_test[3]);
					if praag:owning_faction() == faction and not praag:garrison_residence():is_under_siege() then
						local boris_dilemma_third = cm:create_payload();
						boris_dilemma_third:text_display("dummy_wh3_main_dilemma_boris_unlock_third");
						boris_dilemma:add_choice_payload("THIRD", boris_dilemma_third);
					end;
					
					local boris_dilemma_fourth = cm:create_payload();
					boris_dilemma_fourth:text_display("dummy_wh3_main_dilemma_boris_unlock_fourth");
					boris_dilemma:add_choice_payload("FOURTH", boris_dilemma_fourth);
					
					cm:launch_custom_dilemma_from_builder(boris_dilemma, faction);
					
					core:add_listener(
						"boris_unlock_dilemma_choice",
						"DilemmaChoiceMadeEvent",
						function(context)
							return context:dilemma() == "wh3_main_dilemma_boris_unlock";
						end,
						function(context)
							local faction_name = context:faction():name();
							local choice = context:choice_key();
							local incident = "wh3_main_incident_ksl_boris_unlocked";
							
							if choice == "FIRST" then
								restore_boris(regions_to_test[1], faction_name);
							elseif choice == "SECOND" then
								restore_boris(regions_to_test[2], faction_name);
							elseif choice == "THIRD" then
								restore_boris(regions_to_test[3], faction_name);
							else
								cm:spawn_character_to_pool(faction_name, "names_name_1061845961", "", "", "", 18, true, "general", "wh3_main_ksl_boris", true, "");
								incident = "wh3_main_incident_ksl_boris_unlocked_released";
							end;
							
							cm:trigger_incident(faction_name, incident, true);
							cm:set_saved_value("boris_unlocked", true);
						end,
						false
					);
				end,
				false
			);
		end;
	end;
end;

function restore_boris(region_key, faction_name)
	local function get_spawn_position()
		return cm:find_valid_spawn_location_for_character_from_settlement("wh3_main_ksl_ursun_revivalists", region_key, false, true, 12);
	end;
	
	local x, y = get_spawn_position();
	
	local ram = random_army_manager;
	
	ram:new_force("boris_force");
	
	ram:add_unit("boris_force", "wh3_main_ksl_cav_horse_raiders_0",		8);
	ram:add_unit("boris_force", "wh3_main_ksl_inf_kossars_0",			8);
	ram:add_unit("boris_force", "wh3_main_ksl_inf_kossars_1",			8);
	ram:add_unit("boris_force", "wh3_main_ksl_cav_horse_archers_0",		4);
	ram:add_unit("boris_force", "wh3_main_ksl_cav_winged_lancers_0",	4);
	ram:add_unit("boris_force", "wh3_main_ksl_inf_armoured_kossars_0",	4);
	ram:add_unit("boris_force", "wh3_main_ksl_inf_armoured_kossars_1",	4);
	ram:add_unit("boris_force", "wh3_main_ksl_inf_streltsi_0",			4);
	ram:add_unit("boris_force", "wh3_main_ksl_mon_snow_leopard_0",		4);
	ram:add_unit("boris_force", "wh3_main_ksl_veh_heavy_war_sled_0",	4);
	ram:add_unit("boris_force", "wh3_main_ksl_veh_light_war_sled_0",	4);
	ram:add_unit("boris_force", "wh3_main_ksl_cav_gryphon_legion_0",	1);
	ram:add_unit("boris_force", "wh3_main_ksl_cav_war_bear_riders_1",	1);
	ram:add_unit("boris_force", "wh3_main_ksl_inf_ice_guard_0",			1);
	ram:add_unit("boris_force", "wh3_main_ksl_inf_ice_guard_1",			1);
	ram:add_unit("boris_force", "wh3_main_ksl_inf_tzar_guard_0",		1);
	ram:add_unit("boris_force", "wh3_main_ksl_inf_tzar_guard_1",		1);
	ram:add_unit("boris_force", "wh3_main_ksl_veh_little_grom_0",		1);
	
	cm:create_force(
		"wh3_main_ksl_ursun_revivalists",
		ram:generate_force("boris_force", 7),
		region_key,
		x,
		y,
		false,
		function()
			x, y = get_spawn_position();
			
			cm:create_force_with_existing_general(
				cm:char_lookup_str(cm:get_faction("wh3_main_ksl_ursun_revivalists"):faction_leader():command_queue_index()),
				"wh3_main_ksl_ursun_revivalists",
				ram:generate_force("boris_force", 7),
				region_key,
				x,
				y
			);
			
			cm:transfer_region_to_faction(region_key, "wh3_main_ksl_ursun_revivalists");
			
			cm:force_alliance(faction_name, "wh3_main_ksl_ursun_revivalists", true);
			
			ram:remove_force("boris_force");
		end
	);
end;