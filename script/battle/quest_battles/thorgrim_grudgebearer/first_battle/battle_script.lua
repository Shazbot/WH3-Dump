-- Thorgrim, Intro Subterraneran, Defending
load_script_libraries();

m = battle_manager:new(empire_battle:new());

local gc = generated_cutscene:new(true, true);

gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	false,                                     	-- prevent deployment for ai
	function() gb:start_generated_cutscene(gc) end,			-- intro cutscene function
	false                                      	-- debug mode
);

--generated_cutscene:add_element(sfx_name, subtitle, camera, min_length, wait_for_vo, wait_for_camera, loop_camera)

-- This stops the game playing the regular cutscene if the player has NOT brought Thorgrim into the battle.
if gb:get_army(gb:get_player_alliance_num(), 1):are_unit_types_in_army("wh_main_dwf_cha_high_king_thorgrim_grudgebearer_1") then

	gc:add_element(nil, nil, "gc_slow_absolute_thundering_falls_nwall_01_to_absolute_thundering_falls_nwall_02", 4000, true, false, false); -- Back wall
	gc:add_element("DWF_Thor_GS_Qbattle_prelude_high_king_vs_Grnskns_v2_2_pt_1", "wh_main_qb_dwf_thorgrim_grudgebearer_intro_subterranean_pt_01", nil, 4000, true, false, false); -- Army Rear
	gc:add_element("DWF_Thor_GS_Qbattle_prelude_high_king_vs_Grnskns_v2_2_pt_2", "wh_main_qb_dwf_thorgrim_grudgebearer_intro_subterranean_pt_02", "gc_orbit_90_medium_commander_front_close_low_01", 4000, true, false, false);--General Pan
	gc:add_element("DWF_Thor_GS_Qbattle_prelude_high_king_vs_Grnskns_v2_2_pt_3", "wh_main_qb_dwf_thorgrim_grudgebearer_intro_subterranean_pt_02a", "gc_slow_absolute_thundering_falls_shrine_01_to_absolute_thundering_falls_shrine_02", 4000, true, false, false); -- Bridge
	gc:add_element("DWF_Thor_GS_Qbattle_prelude_high_king_vs_Grnskns_v2_2_pt_4", "wh_main_qb_dwf_thorgrim_grudgebearer_intro_subterranean_pt_03", "qb_final_position_sub_short", 4000, true, false, false);-- Army Pan
else

	gc:add_element(nil, nil, "gc_slow_absolute_thundering_falls_nwall_01_to_absolute_thundering_falls_nwall_02", 5000, false, false, false); -- Back wall
	gc:add_element(nil, nil, "gc_slow_absolute_thundering_falls_waterfalls_01_to_absolute_thundering_falls_waterfalls_02", 5000, false, false, false); -- Falls
	gc:add_element(nil, nil, "gc_slow_absolute_thundering_falls_entrance_01_to_absolute_thundering_falls_entrance_02", 5000, false, false, false); -- Bridge
	gc:add_element(nil, nil, "qb_final_position_sub_short", 5000, false, true, false);-- Army Pan
end

gb:set_cutscene_during_deployment(true);

-------AUDIO-------
Ambush_VO = new_sfx("Play_DWF_Thor_Qbattle_prelude_high_king_post_ambush_vs_Grnskns_v1", false, true);
Rear_Attack_01_VO = new_sfx("Play_DWF_Unq4_CS_Enemy_Rear", false, true);
Left_Attack_VO = new_sfx("Play_DWF_Inf4_CS_Enemy_Flanking_02", false, true);


-------ARMY SETUP-------
ga_player_01 = gb:get_army(gb:get_player_alliance_num(), 1);		
ga_player_01_gyrocopters = gb:get_army(gb:get_player_alliance_num(), 2);
				
ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(), 1);
ga_ai_trolls = gb:get_army(gb:get_non_player_alliance_num(), 2, "trolls");
ga_ai_left = gb:get_army(gb:get_non_player_alliance_num(), 2, "left");
ga_ai_left_2 = gb:get_army(gb:get_non_player_alliance_num(), 2, "left_2");
ga_ai_right = gb:get_army(gb:get_non_player_alliance_num(), 2, "right");
ga_ai_right_2 = gb:get_army(gb:get_non_player_alliance_num(), 2, "right_2");


-------OBJECTIVES-------
gb:set_objective_on_message("deployment_started", "wh_main_qb_dwf_thorgrim_grudgebearer_intro_battle_main_objective");

-------HINTS-------
gb:queue_help_on_message("battle_started", "wh_main_qb_dwf_thorgrim_grudgebearer_intro_battle_hint_objective", 5000, 1000, 1000);
gb:queue_help_on_message("start_right", "wh_main_qb_dwf_thorgrim_grudgebearer_intro_subterranean_extra", 5000, 1000, 1000);
gb:queue_help_on_message("start_trolls", "wh_main_qb_dwf_thorgrim_grudgebearer_intro_battle_giant", 5000, 1000, 1000);


-------ORDERS-------
ga_ai_01:halt();
gb:message_on_time_offset("attack", 5000);
ga_ai_01:release_on_message("attack");

-- Battle Timings
gb:message_on_time_offset("start_right", 10000);
gb:message_on_time_offset("start_right_2", 12000);

gb:message_on_time_offset("start_left", 70000);
gb:message_on_time_offset("start_left_2", 90000);

gb:message_on_time_offset("start_trolls", 180000);
gb:message_on_time_offset("remove_trolls_objective", 260000);

ga_ai_01:message_on_proximity_to_enemy("player_reinforcements", 40);


--RIGHT HAND SIDE SPAWNS
ga_ai_right:reinforce_on_message("start_right");

--only play thorgrim vo if thorgrim is actually here to say it
if gb:get_army(gb:get_player_alliance_num(), 1):are_unit_types_in_army("wh_main_dwf_cha_high_king_thorgrim_grudgebearer_1") then
	gb:play_sound_on_message("start_right", Ambush_VO, nil, 7000);
end

ga_ai_right_2:reinforce_on_message("start_right_2", 1000);
	
	
--LEFT HAND SIDE SPAWNS
ga_ai_left:reinforce_on_message("start_left");
gb:play_sound_on_message("start_left", Left_Attack_VO, nil, 7000);

ga_ai_left_2:reinforce_on_message("start_left_2");
	
--REAR SPAWNS
ga_ai_trolls:reinforce_on_message("start_trolls");
gb:play_sound_on_message("start_trolls", Rear_Attack_01_VO, nil, 6000);

--PLAYER REINFORCEMENT
ga_player_01_gyrocopters:reinforce_on_message("player_reinforcements");
gb:play_sound_on_message("start_trolls", Orc_Horn, v(-300, 100, -660), 3000);

ga_player_01:message_on_rout_proportion("player_dead", 1);
ga_ai_01:force_victory_on_message("player_dead");  