load_script_libraries();

bm = battle_manager:new(empire_battle:new());

bm:camera():fade(true, 0);

gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	false,                                     	-- prevent deployment for ai
	function() play_intro_cutscene() end,      -- intro cutscene function -- nil, --
	false                                      	-- debug mode
);

---------------------------
----HARD SCRIPT VERSION----
--------------------------- 

bm:notify_survival_started();
bm:force_cant_chase_down_routers();
bm:notify_survival_total_waves(4);

required_waves_kills = 4;

local sm = get_messager();
survival_mode = {};

intro_cinematic_file = "script\\battle\\survival_battles\\_cutscene\\managers\\coc_altar_azazel_phase_one.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);
reveal_cinematic_file = "script\\battle\\survival_battles\\_cutscene\\managers\\coc_altar_final_phase_two.CindySceneManager";
bm:cindy_preload(reveal_cinematic_file);

bm:force_custom_battle_result("wh3_dlc20_survival_altar_of_battle_victory", true);
bm:force_custom_battle_result("wh3_dlc20_survival_altar_of_battle_defeat", false);

gb:set_cutscene_during_deployment(true);


------ COMPOSITE SCENES --------

altar_capture = "composite_scene/wh3_dlc20_enviro_altar_of_battle_lightning_event_final.csc";
altar_cracks_1_start = "composite_scene/wh3_dlc20_enviro_altar_of_battle_glowing_cracks_middle.csc";
altar_cracks_2_capture = "composite_scene/wh3_dlc20_enviro_altar_of_battle_glowing_cracks_middle_complete.csc";
altar_cracks_3_loop = "composite_scene/wh3_dlc20_enviro_altar_of_battle_glowing_cracks_middle_cont.csc";
cp_1_1_cracks = "composite_scene/wh3_dlc20_enviro_altar_of_battle_glowing_cracks_2.csc";
cp_1_1_cracks_loop = "composite_scene/wh3_dlc20_enviro_altar_of_battle_glowing_cracks_2_cont.csc";
cp_1_2_cracks = "composite_scene/wh3_dlc20_enviro_altar_of_battle_glowing_cracks_1.csc";
cp_1_2_cracks_loop = "composite_scene/wh3_dlc20_enviro_altar_of_battle_glowing_cracks_1_cont.csc";
cp_2_1_cracks = "composite_scene/wh3_dlc20_enviro_altar_of_battle_glowing_cracks_3.csc";
cp_2_1_cracks_loop = "composite_scene/wh3_dlc20_enviro_altar_of_battle_glowing_cracks_3_cont.csc";
cp_2_2_cracks = "composite_scene/wh3_dlc20_enviro_altar_of_battle_glowing_cracks_4.csc";
cp_2_2_cracks_loop = "composite_scene/wh3_dlc20_enviro_altar_of_battle_glowing_cracks_4_cont.csc";

bm:start_terrain_composite_scene(altar_capture, nil, 0);
bm:stop_terrain_composite_scene(altar_capture);

bm:start_terrain_composite_scene(altar_cracks_1_start, nil, 0);
bm:stop_terrain_composite_scene(altar_cracks_1_start);
bm:start_terrain_composite_scene(altar_cracks_2_capture, nil, 0);
bm:stop_terrain_composite_scene(altar_cracks_2_capture);
bm:start_terrain_composite_scene(altar_cracks_3_loop, nil, 0);
bm:stop_terrain_composite_scene(altar_cracks_3_loop);

bm:start_terrain_composite_scene(cp_1_1_cracks, nil, 0);
bm:stop_terrain_composite_scene(cp_1_1_cracks);
bm:start_terrain_composite_scene(cp_1_1_cracks_loop, nil, 0);
bm:stop_terrain_composite_scene(cp_1_1_cracks_loop);
bm:start_terrain_composite_scene(cp_1_2_cracks, nil, 0);
bm:stop_terrain_composite_scene(cp_1_2_cracks);
bm:start_terrain_composite_scene(cp_1_2_cracks_loop, nil, 0);
bm:stop_terrain_composite_scene(cp_1_2_cracks_loop);
bm:start_terrain_composite_scene(cp_2_1_cracks, nil, 0);
bm:stop_terrain_composite_scene(cp_2_1_cracks);
bm:start_terrain_composite_scene(cp_2_1_cracks_loop, nil, 0);
bm:stop_terrain_composite_scene(cp_2_1_cracks_loop);
bm:start_terrain_composite_scene(cp_2_2_cracks, nil, 0);
bm:stop_terrain_composite_scene(cp_2_2_cracks);
bm:start_terrain_composite_scene(cp_2_2_cracks_loop, nil, 0);
bm:stop_terrain_composite_scene(cp_2_2_cracks_loop);

-------------------------------------------------------------------------------------------------
-------------------------------------------ARMY SETUP--------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player_01 = gb:get_army(gb:get_player_alliance_num(), 1);
ga_player_02 = gb:get_army(gb:get_player_alliance_num(), "player_reinforce");


ga_ai_def_01 = gb:get_army(gb:get_non_player_alliance_num(), "ai_def_01");			-- initial army already present on map at battle start, defeat to unlock cp

ga_ai_att_01_1 = gb:get_army(gb:get_non_player_alliance_num(), "wave_01_1");		-- army that spawns when 1st cp captured, which player must then defend against
ga_ai_att_01_2 = gb:get_army(gb:get_non_player_alliance_num(), "wave_01_2");

ga_ai_att_02_1 = gb:get_army(gb:get_non_player_alliance_num(), "wave_02_1");		-- army that spawns when 2nd cp captured, which player must then defend against
ga_ai_att_02_2 = gb:get_army(gb:get_non_player_alliance_num(), "wave_02_2");

ga_ai_att_03_1 = gb:get_army(gb:get_non_player_alliance_num(), "wave_03_1");		-- (left) boss wave units that spawn periodically
ga_ai_att_03_2 = gb:get_army(gb:get_non_player_alliance_num(), "wave_03_2");		-- (right)
ga_ai_att_03_3 = gb:get_army(gb:get_non_player_alliance_num(), "wave_03_3");		-- (top/north)

ga_ai_att_04 = gb:get_army(gb:get_non_player_alliance_num(), "ai_boss");			-- the big bad
ga_ai_att_05 = gb:get_army(gb:get_non_player_alliance_num(), "ai_boss_backup");		-- the big bads close mates


ga_ai_att_01_1:get_army():suppress_reinforcement_adc(1);
ga_ai_att_01_2:get_army():suppress_reinforcement_adc(1);
ga_ai_att_02_1:get_army():suppress_reinforcement_adc(1);
ga_ai_att_02_2:get_army():suppress_reinforcement_adc(1);
ga_ai_att_03_1:get_army():suppress_reinforcement_adc(1);
ga_ai_att_03_2:get_army():suppress_reinforcement_adc(1);
ga_ai_att_03_3:get_army():suppress_reinforcement_adc(1);
ga_ai_att_04:get_army():suppress_reinforcement_adc(1);
ga_ai_att_05:get_army():suppress_reinforcement_adc(1);


-- makes units disable at start of battle
--ga_ai_def_02.sunits:set_enabled(false);	
--ga_ai_def_03.sunits:set_enabled(false);
--ga_ai_att_04.sunits:set_enabled(false);

-- build spawn zone collections
sz_collection_1_left = bm:get_spawn_zone_collection_by_name("attacker_stage_1_left", "attacker_flow");
sz_collection_1_right = bm:get_spawn_zone_collection_by_name("attacker_stage_1_right", "attacker_flow");
sz_collection_2_left = bm:get_spawn_zone_collection_by_name("attacker_stage_2_left");
sz_collection_2_right = bm:get_spawn_zone_collection_by_name("attacker_stage_2_right");
sz_collection_3_left = bm:get_spawn_zone_collection_by_name("attacker_stage_3_left");
sz_collection_3_right = bm:get_spawn_zone_collection_by_name("attacker_stage_3_right");
sz_collection_3_top = bm:get_spawn_zone_collection_by_name("attacker_stage_3_north");
sz_collection_4 = bm:get_spawn_zone_collection_by_name("attacker_boss");
sz_collection_5 = bm:get_spawn_zone_collection_by_name("attacker_boss_backup");
sz_collection_6 = bm:get_spawn_zone_collection_by_name("attacker_flow");

local reinforcements = bm:reinforcements();

-------------------------------------------------------------------------------------------------
--------------------------------------- CAPTURE LOCATIONS ---------------------------------------
-------------------------------------------------------------------------------------------------

local capture_point_01 = bm:capture_location_manager():capture_location_from_script_id("cp_1_1");				-- magic
local capture_point_02 = bm:capture_location_manager():capture_location_from_script_id("cp_1_2");				-- leadership
local capture_point_03 = bm:capture_location_manager():capture_location_from_script_id("cp_2_1");				-- defence
local capture_point_04 = bm:capture_location_manager():capture_location_from_script_id("cp_2_2");				-- melee
local capture_point_05 = bm:capture_location_manager():capture_location_from_script_id("cp_altar_of_battle");	-- replenishment (altar)

reinforcements:link_support_units_event_with_capture_point("unlock_support_units_event_cp_1", capture_point_01);
reinforcements:link_support_units_event_with_capture_point("unlock_support_units_event_cp_1", capture_point_02);
reinforcements:link_support_units_event_with_capture_point("unlock_support_units_event_cp_3", capture_point_03);
reinforcements:link_support_units_event_with_capture_point("unlock_support_units_event_cp_3", capture_point_04);
reinforcements:link_support_units_event_with_capture_point("unlock_support_units_event_cp_5", capture_point_05);	-- altar

capture_point_01:set_locked(true);
capture_point_02:set_locked(true);
capture_point_03:set_locked(true);
capture_point_04:set_locked(true);
capture_point_05:set_locked(true);	-- altar


------ CAPTURE LOCATION UNLOCKING SEQUENCE ------

ga_ai_def_01:message_on_rout_proportion("def_01_dead", 0.9);
ga_ai_def_01:rout_over_time_on_message("def_01_dead", 3000); 

gb:add_listener(
	"def_01_dead",
	function()
		capture_point_01:set_locked(false);	-- unlocks first set of capture points when initial defending army dead
		capture_point_02:set_locked(false);
	end
);

gb:add_listener(
	"ready_ai_wave_02",
	function()
		capture_point_03:set_locked(false);
		capture_point_04:set_locked(false);
	end
);

gb:add_listener(
	"ready_ai_wave_03",
	function()
		capture_point_05:set_locked(false);
		capture_point_05:highlight(true);
	end
);

gb:message_on_capture_location_capture_completed("cp_1_1_owned", "battle_start", "cp_1_1", nil, nil, ga_player_01);	-- potentially make these nil,nil, or update to wave armies?
gb:message_on_capture_location_capture_completed("cp_1_2_owned", "battle_start", "cp_1_2", nil, nil, ga_player_01);

--gb:message_on_capture_location_capture_commenced("cp_1_1_commenced", "battle_start", "cp_1_1", nil, ga_ai_def_01, ga_player_01);
--gb:message_on_capture_location_capture_commenced("cp_1_2_commenced", "battle_start", "cp_1_2", nil, ga_ai_def_01, ga_player_01);
gb:start_terrain_composite_scene_on_message("cp_1_1_owned", cp_1_1_cracks);
gb:start_terrain_composite_scene_on_message("cp_1_2_owned", cp_1_2_cracks);
gb:stop_terrain_composite_scene_on_message("cp_1_1_owned", cp_1_1_cracks, 10000);
gb:stop_terrain_composite_scene_on_message("cp_1_2_owned", cp_1_2_cracks, 10000);
gb:start_terrain_composite_scene_on_message("cp_1_1_owned", cp_1_1_cracks_loop, 10000);
gb:start_terrain_composite_scene_on_message("cp_1_2_owned", cp_1_2_cracks_loop, 10000);

gb:add_listener(
	"cp_1_1_owned",
	function()
		reinforcements:unlock_support_units_event("unlock_support_units_event_cp_1");
		capture_point_02:change_holding_army(ga_ai_att_01_1.army);
		capture_point_02:set_locked(true);
		capture_point_01:change_holding_army(ga_player_01.army);
		capture_point_01:set_locked(true);
		--bm:start_terrain_composite_scene(cp_1_1_cracks_loop, nil, 0)
	end
);

gb:add_listener(
	"cp_1_2_owned",
	function()
		reinforcements:unlock_support_units_event("unlock_support_units_event_cp_1");
		capture_point_01:change_holding_army(ga_ai_att_01_1.army);
		capture_point_01:set_locked(true);
		capture_point_02:change_holding_army(ga_player_01.army);
		capture_point_02:set_locked(true);
		--bm:start_terrain_composite_scene(cp_1_2_cracks_loops, nil, 0)
	end
);

gb:message_on_capture_location_capture_completed("cp_2_1_owned", "ready_ai_wave_02", "cp_2_1", nil, nil, ga_player_01);
gb:message_on_capture_location_capture_completed("cp_2_2_owned", "ready_ai_wave_02", "cp_2_2", nil, nil, ga_player_01);
--gb:message_on_capture_location_capture_completed("cp_2_lost", "ready_ai_wave_02", "cp_2_1", nil, ga_player_01, ga_ai_def_01);
--gb:message_on_capture_location_capture_completed("cp_2_lost", "ready_ai_wave_02", "cp_2_2", nil, ga_player_01, ga_ai_def_01);

gb:start_terrain_composite_scene_on_message("cp_2_1_owned", cp_2_1_cracks);
gb:start_terrain_composite_scene_on_message("cp_2_2_owned", cp_2_2_cracks);
gb:stop_terrain_composite_scene_on_message("cp_2_1_owned", cp_2_1_cracks, 10000);
gb:stop_terrain_composite_scene_on_message("cp_2_2_owned", cp_2_2_cracks, 10000);
gb:start_terrain_composite_scene_on_message("cp_2_1_owned", cp_2_1_cracks_loop, 10000);
gb:start_terrain_composite_scene_on_message("cp_2_2_owned", cp_2_2_cracks_loop, 10000);

gb:add_listener(
	"cp_2_1_owned",
	function()
		reinforcements:unlock_support_units_event("unlock_support_units_event_cp_3");
		capture_point_04:change_holding_army(ga_ai_att_02_1.army);
		capture_point_04:set_locked(true);
		capture_point_03:change_holding_army(ga_player_01.army);
		capture_point_03:set_locked(true);
		--bm:start_terrain_composite_scene(cp_2_1_cracks, nil, 0)
	end
);

gb:add_listener(
	"cp_2_2_owned",
	function()
		reinforcements:unlock_support_units_event("unlock_support_units_event_cp_3");
		capture_point_03:change_holding_army(ga_ai_att_02_1.army);
		capture_point_03:set_locked(true);
		capture_point_04:change_holding_army(ga_player_01.army);
		capture_point_04:set_locked(true);
		--bm:start_terrain_composite_scene(cp_2_2_cracks, nil, 0)
	end
);
--[[					-- not needed?
gb:add_listener(
	"cp_2_lost",
	function()
		capture_point_01:set_locked(false);
	end
);
]]

gb:message_on_capture_location_capture_commenced("cp_3_capture_commenced", "ready_ai_wave_03", "cp_altar_of_battle", nil, nil, ga_player_01);

gb:message_on_capture_location_capture_completed("cp_3_owned", "ready_ai_wave_03", "cp_altar_of_battle", nil, nil, ga_player_01);
gb:message_on_capture_location_capture_completed("cp_3_lost", "ready_ai_wave_03", "cp_altar_of_battle", nil, ga_player_01, ga_ai_att_04);

gb:start_terrain_composite_scene_on_message("cp_3_capture_commenced", altar_cracks_1_start, 0);
gb:start_terrain_composite_scene_on_message("cp_3_owned", altar_capture, 1000);

gb:stop_terrain_composite_scene_on_message("cp_3_owned", altar_cracks_1_start);
gb:start_terrain_composite_scene_on_message("cp_3_owned", altar_cracks_2_capture);
gb:stop_terrain_composite_scene_on_message("cp_3_owned", altar_cracks_2_capture, 10000);
gb:start_terrain_composite_scene_on_message("cp_3_owned", altar_cracks_3_loop, 10000);

ga_player_01:add_winds_of_magic_reserve_on_message("cp_3_owned", 50);

gb:add_listener(
	"cp_3_owned",
	function()
		reinforcements:unlock_support_units_event("unlock_support_units_event_cp_5");
		capture_point_01:change_holding_army(ga_player_01.army);
		capture_point_02:change_holding_army(ga_player_01.army);
		capture_point_03:change_holding_army(ga_player_01.army);
		capture_point_04:change_holding_army(ga_player_01.army);
		capture_point_01:set_locked(false);
		capture_point_02:set_locked(false);
		capture_point_03:set_locked(false);
		capture_point_04:set_locked(false);
		capture_point_05:highlight(false);
		--bm:start_terrain_composite_scene(altar_capture, nil, 0)
		--bm:start_terrain_composite_scene(altar_cracks, nil, 0)
	end
);

gb:add_listener(
	"cp_3_lost",
	function()
		--capture_point_01:set_locked(false);
		--capture_point_02:set_locked(false);
		--capture_point_03:set_locked(false);
		--capture_point_04:set_locked(false);
	end
);

-- Setup Currency Caps
capture_point_01:set_income_cap_for_alliance(bm:get_player_alliance(), 2000.0);
capture_point_02:set_income_cap_for_alliance(bm:get_player_alliance(), 2000.0);
capture_point_03:set_income_cap_for_alliance(bm:get_player_alliance(), 2000.0);
capture_point_04:set_income_cap_for_alliance(bm:get_player_alliance(), 2000.0);
capture_point_05:set_income_cap_for_alliance(bm:get_player_alliance(), 1000.0);	-- altar

reinforcements:set_cost_based_support_units_event("unlock_support_units_event_cp_1", 0, 1000);
reinforcements:set_cost_based_support_units_event("unlock_support_units_event_cp_1", 0, 1000);
reinforcements:set_cost_based_support_units_event("unlock_support_units_event_cp_3", 1000, 1500);
reinforcements:set_cost_based_support_units_event("unlock_support_units_event_cp_3", 1000, 1500);
reinforcements:set_cost_based_support_units_event("unlock_support_units_event_cp_5", 1500, 9999999);	-- altar


-----WAVE 1_1-----	left
ga_ai_att_01_1:assign_to_spawn_zone_from_collection_on_message("ai_wave_01", sz_collection_1_left, false);
ga_ai_att_01_1:message_on_number_deployed("1_1_deployed", true, 1);
ga_ai_att_01_1:assign_to_spawn_zone_from_collection_on_message("1_1_deployed", sz_collection_1_left, false);

-----WAVE 1_2-----	right
ga_ai_att_01_2:assign_to_spawn_zone_from_collection_on_message("ai_wave_01", sz_collection_1_right, false);
ga_ai_att_01_2:message_on_number_deployed("1_2_deployed", true, 1);
ga_ai_att_01_2:assign_to_spawn_zone_from_collection_on_message("1_2_deployed", sz_collection_1_right, false);

-----WAVE 2_1-----	left
ga_ai_att_02_1:assign_to_spawn_zone_from_collection_on_message("ai_wave_02", sz_collection_2_left, false);
ga_ai_att_02_1:message_on_number_deployed("2_1_deployed", true, 1);
ga_ai_att_02_1:assign_to_spawn_zone_from_collection_on_message("2_1_deployed", sz_collection_2_left, false);

-----WAVE 2_2-----	right
ga_ai_att_02_2:assign_to_spawn_zone_from_collection_on_message("ai_wave_02", sz_collection_2_right, false);
ga_ai_att_02_2:message_on_number_deployed("2_2_deployed", true, 1);
ga_ai_att_02_2:assign_to_spawn_zone_from_collection_on_message("2_2_deployed", sz_collection_2_right, false);

-----WAVE 3_1-----	left
ga_ai_att_03_1:assign_to_spawn_zone_from_collection_on_message("ai_wave_03", sz_collection_3_left, false);
ga_ai_att_03_1:message_on_number_deployed("3_1_deployed", true, 1);
ga_ai_att_03_1:assign_to_spawn_zone_from_collection_on_message("3_1_deployed", sz_collection_3_left, false);

-----WAVE 3_2-----	right
ga_ai_att_03_2:assign_to_spawn_zone_from_collection_on_message("ai_wave_03", sz_collection_3_right, false);
ga_ai_att_03_2:message_on_number_deployed("3_2_deployed", true, 1);
ga_ai_att_03_2:assign_to_spawn_zone_from_collection_on_message("3_2_deployed", sz_collection_3_right, false);

-----WAVE 3_3-----	top/north
ga_ai_att_03_3:assign_to_spawn_zone_from_collection_on_message("ai_wave_03", sz_collection_3_top, false);
ga_ai_att_03_3:message_on_number_deployed("3_3_deployed", true, 1);
ga_ai_att_03_3:assign_to_spawn_zone_from_collection_on_message("3_3_deployed", sz_collection_3_top, false);

------WAVE BOSS MAN------
ga_ai_att_04:assign_to_spawn_zone_from_collection_on_message("prepare_reveal", sz_collection_4, false);
ga_ai_att_04:message_on_number_deployed("4_deployed", true, 1);
ga_ai_att_04:assign_to_spawn_zone_from_collection_on_message("4_deployed", sz_collection_4, false);

------WAVE BOSS BACKUP------
ga_ai_att_05:assign_to_spawn_zone_from_collection_on_message("reveal_cutscene_end", sz_collection_5, false);
ga_ai_att_05:message_on_number_deployed("5_deployed", true, 1);
ga_ai_att_05:assign_to_spawn_zone_from_collection_on_message("5_deployed", sz_collection_5, false);


-- Example: Set random deployment position in a reinforcement line..
for i = 1, reinforcements:attacker_reinforcement_lines_count() do
	
	local line = reinforcements:attacker_reinforcement_line(i);
	
	if (line:script_id() == "attacker_stage_1_left") then
		line:enable_random_deployment_position();		
	end

	if (line:script_id() == "attacker_stage_1_right") then
		line:enable_random_deployment_position();		
	end

	if (line:script_id() == "attacker_stage_2_left") then
		line:enable_random_deployment_position();		
	end

	if (line:script_id() == "attacker_stage_2_right") then
		line:enable_random_deployment_position();		
	end

	if (line:script_id() == "attacker_stage_3_left") then
		line:enable_random_deployment_position();		
	end

	if (line:script_id() == "attacker_stage_3_right") then
		line:enable_random_deployment_position();		
	end

	if (line:script_id() == "attacker_stage_3_north") then
		line:enable_random_deployment_position();		
	end

	if (line:script_id() == "attacker_boss_backup") then
		line:enable_random_deployment_position();		
	end

	if (line:script_id() == "attacker_flow") then
		line:enable_random_deployment_position();		
	end
end;

bm:print_toggle_slots()
bm:print_capture_locations()


-------------------------------------------------------------------------------------------------
------------------------------------------ INTRO VO ---------------------------------------------
-------------------------------------------------------------------------------------------------

wh3_intro_sfx_00 = new_sfx("Play_Movie_WH3_DLC20_QB_Altar_Of_Battle_Azazel_Intro");


wh3_intro_sfx_01 = new_sfx("play_wh3_dlc20_qb_azazel_altar_of_battle_intro_001");
wh3_intro_sfx_02 = new_sfx("play_wh3_dlc20_qb_azazel_altar_of_battle_intro_002");
wh3_intro_sfx_03 = new_sfx("play_wh3_dlc20_qb_azazel_altar_of_battle_intro_003");
wh3_intro_sfx_04 = new_sfx("play_wh3_dlc20_qb_azazel_altar_of_battle_intro_004");
wh3_intro_sfx_05 = new_sfx("play_wh3_dlc20_qb_azazel_altar_of_battle_intro_005");
wh3_intro_sfx_06 = new_sfx("play_wh3_dlc20_qb_azazel_altar_of_battle_intro_006");

-------------------------------------------------------------------------------------------------
------------------------------------------ WAVE VO ----------------------------------------------
-------------------------------------------------------------------------------------------------

wh3_wave_sfx_01 = new_sfx("play_wh3_dlc20_qb_azazel_altar_of_battle_phase2a_001");
wh3_wave_sfx_02 = new_sfx("play_wh3_dlc20_qb_azazel_altar_of_battle_phase2b_001");
wh3_wave_sfx_03 = new_sfx("play_wh3_dlc20_qb_azazel_altar_of_battle_phase2c_001");		-- altar accessable line

-------------------------------------------------------------------------------------------------
------------------------------------------ REVEAL VO --------------------------------------------
-------------------------------------------------------------------------------------------------

wh3_reveal_sfx_00 = new_sfx("Play_Movie_WH3_DLC20_QB_Altar_Of_Battle_Archaon_Reveal");	

wh3_reveal_sfx_01 = new_sfx("play_wh3_dlc20_final_battle_narrator_07");
wh3_reveal_sfx_02 = new_sfx("play_wh3_dlc20_final_battle_narrator_08");
wh3_reveal_sfx_03 = new_sfx("play_Chaos_Arc_Sel_Gen_06");
wh3_reveal_sfx_04 = new_sfx("play_wh3_dlc20_qb_azazel_altar_of_battle_phase3_001");

-- OUTRO --
wh3_outro_sfx_00 = new_sfx("WH3_DLC20_QB_Altar_Of_Battle_Sweetener_03");

-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO CUTSCENE -----------------------------------------
-------------------------------------------------------------------------------------------------

function play_intro_cutscene()
	
	local cam = bm:camera();
	cam_pos_intro = cam:position();
	cam_targ_intro = cam:target();


	cam:fade(false, 2);
	
	local cutscene_intro = cutscene:new_from_cindyscene(
        -- unique string name for cutscene
        "cutscene_intro",
        -- unitcontroller or scriptunits collection over player's army
        ga_player_01.sunits,
        -- end callback
        function() end_intro_cutscene() end,
        -- path to cindy scene
        intro_cinematic_file,
        -- optional fade in/fade out durations
        0,
        0
	);

	-- skip callback
	cutscene_intro:set_skippable(
		true, 
		function()
			bm:stop_cindy_playback(true);
		end
	);

	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(true, 0.5) end, 76300); --23s

	-- set up subtitles
	local subtitles = cutscene_intro:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();

	--Voiceover and Subtitles --
	cutscene_intro:action(function() cutscene_intro:play_sound(wh3_intro_sfx_00) end, 100);

	-- Finally, my destiny has arrived. The spoils within that Altar ensure a place at my master’s side. N’Kari… Sigvald… will not even be worthy enough to kiss my claw!
	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_dlc20_qb_azazel_altar_of_battle_intro_01", 
			function()
				cutscene_intro:play_sound(wh3_intro_sfx_01);
				bm:show_subtitle("wh3_dlc20_qb_azazel_altar_of_battle_intro_01", false, true);
			end
	);

	-- First, I must break open the Altar to gain the Dark Prince’s favour. It shall be my greatest endeavour!
	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_dlc20_qb_azazel_altar_of_battle_intro_02", 
			function()
				cutscene_intro:play_sound(wh3_intro_sfx_02);
				bm:show_subtitle("wh3_dlc20_qb_azazel_altar_of_battle_intro_02", false, true);
			end
	);

	-- I need only claim enough of the Altar’s Marks of Power - and depose any who dare get in my way! What fun we shall have!
	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_dlc20_qb_azazel_altar_of_battle_intro_03", 
			function()
				cutscene_intro:play_sound(wh3_intro_sfx_03);
				bm:show_subtitle("wh3_dlc20_qb_azazel_altar_of_battle_intro_03", false, true);
			end
	);

	-- So, the Blood God sends forth his murderous peons… 
	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_dlc20_qb_azazel_altar_of_battle_intro_04", 
			function()
				cutscene_intro:play_sound(wh3_intro_sfx_04);
				bm:show_subtitle("wh3_dlc20_qb_azazel_altar_of_battle_intro_04", false, true);
			end
	);

	-- Mindless bludgeons! Unworthy of my time. Have my minions see to them!
	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_dlc20_qb_azazel_altar_of_battle_intro_05", 
			function()
				cutscene_intro:play_sound(wh3_intro_sfx_05);
				bm:show_subtitle("wh3_dlc20_qb_azazel_altar_of_battle_intro_05", false, true);
			end
	);

	-- There is only one champion worthy of the spoils inside that Altar - and it is not Khorne’s!
	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_dlc20_qb_azazel_altar_of_battle_intro_06", 
			function()
				cutscene_intro:play_sound(wh3_intro_sfx_06);
				bm:show_subtitle("wh3_dlc20_qb_azazel_altar_of_battle_intro_06", false, true);
			end
	);

	--cutscene_intro:set_music("Final_Battle_Intro", 0, 0)

	cutscene_intro:start();
end;

function end_intro_cutscene()
	ga_player_01.sunits:set_always_visible_no_hidden_no_leave_battle(true)
	ga_player_01.sunits:release_control()
	cam:move_to(cam_pos_intro, cam_targ_intro, 0.25)
	cam:fade(false, 2)
	bm:hide_subtitles()
end;

-------------------------------------------------------------------------------------------------
--------------------------------------- REVEAL CUTSCENE -----------------------------------------
-------------------------------------------------------------------------------------------------

function prepare_for_reveal_cutscene()
    --fade to black over 0.5 seconds
    bm:camera():fade(true, 0.5)

    -- play boss reveal cutscene after 1 second
    bm:callback(function() play_reveal_cutscene() end, 1000)
end

function play_reveal_cutscene()
    
	--gb.sm:trigger_message("teleport_archaon")
	
	local cam_reveal = bm:camera();
	cam_pos_reveal = cam:position();
	cam_targ_reveal = cam:target();
	
	cam_reveal:fade(false, 2);

	local reveal_units_hidden = false;

	local cutscene_reveal = cutscene:new_from_cindyscene(
        -- unique string name for cutscene
        "cutscene_reveal",
        -- unitcontroller or scriptunits collection over player's army
        ga_player_01.sunits,
        -- end callback
        function() end_reveal_cutscene() end,
        -- path to cindy scene
        reveal_cinematic_file,
        -- optional fade in/fade out durations
        0,
        0
	);

		-- skip callback
		cutscene_reveal:set_skippable(
			true, 
			function()
				local cam_reveal = bm:camera();
				cam_reveal:fade(true, 0);
				bm:stop_cindy_playback(true);
				--[[
				if reveal_units_hidden then
					ga_player_01.sunits:set_enabled(false)
					ga_player_02.sunits:set_enabled(false)
				end;]]
	
				bm:callback(function() cam:fade(false, 0.5) end, 1000);
			end
		);

	-- set up actions on cutscene
	cutscene_reveal:action(function() cam:fade(true, 0.5) end, 24500); --25s

	cutscene_reveal:action(
		function()
			--[[reveal_units_hidden = true;
			ga_player_01.sunits:set_enabled(false)
			ga_player_02.sunits:set_enabled(false)]]
			ga_player_01.sunits:set_invisible_to_all(true)
			ga_player_02.sunits:set_invisible_to_all(true)
			--ga_ai_att_04.sunits:invincible_if_standing(true)
		end, 
		100
	);

	--Voiceover and Subtitles --
	cutscene_reveal:action(function() cutscene_reveal:play_sound(wh3_reveal_sfx_00) end, 100);

	-- For Chaos to achieve total destruction of the mortal realm, one God cannot dominate the others.  
	cutscene_reveal:add_cinematic_trigger_listener(
	 	"wh3_dlc20_qb_all_altar_of_battle_reveal_01", 
	 		function()
				cutscene_reveal:play_sound(wh3_reveal_sfx_01);
	 			bm:show_subtitle("wh3_dlc20_qb_all_altar_of_battle_reveal_01", false, true);
	 		end
	);

	-- The Everchosen comes to stop the final ritual! 
	cutscene_reveal:add_cinematic_trigger_listener(
	 	"wh3_dlc20_qb_all_altar_of_battle_reveal_02", 
	 		function()
				cutscene_reveal:play_sound(wh3_reveal_sfx_02);
	 			bm:show_subtitle("wh3_dlc20_qb_all_altar_of_battle_reveal_02", false, true);
	 		end
	);

	-- Do not meddle in my destiny! 
	cutscene_reveal:add_cinematic_trigger_listener(
	 	"wh3_dlc20_qb_all_altar_of_battle_reveal_03", 
	 		function()
				cutscene_reveal:play_sound(wh3_reveal_sfx_03);
	 			bm:show_subtitle("wh3_dlc20_qb_all_altar_of_battle_reveal_03", false, true);
	 		end
	);

	cutscene_reveal:set_music("Altar_Of_Battle_Archaon_Reveal", 0, 0)

	cutscene_reveal:start();
end;

function end_reveal_cutscene()
	gb.sm:trigger_message("reveal_cutscene_end")
	gb.sm:trigger_message("teleport_archaon")
	cam:move_to(cam_pos_reveal, cam_targ_reveal, 0.25)
	--ga_player_01.sunits:set_enabled(true)
	--ga_player_02.sunits:set_enabled(true)
	ga_player_01.sunits:set_invisible_to_all(false)
	ga_player_02.sunits:set_invisible_to_all(false)
	ga_player_01.sunits:release_control()
	ga_player_02.sunits:release_control()
	--ga_ai_att_04.sunits:set_invincible(false)
	cam:fade(false, 2)
	bm:hide_subtitles()
end;

-- You are nothing to me, Everchosen!
gb:play_sound_on_message("reveal_cutscene_end", wh3_reveal_sfx_04, nil, 4000, nil, 500)

-------------------------------------------------------------------------------------------------
---------------------------------------- OUTRO CUTSCENE -----------------------------------------	-- kept just to give a short final overview shot before battle end
-------------------------------------------------------------------------------------------------

function prepare_for_outro_cutscene()
    --fade to black over 1 seconds
    bm:camera():fade(true, 1.0)

	--bm:stop_terrain_composite_scene()

    -- play outro cutscene after 1 second
    bm:callback(function() play_outro_cutscene() end, 1000)
end

function play_outro_cutscene()

	local cam_outro = bm:camera();
	cam_pos_outro = cam:position();
	cam_targ_outro = cam:target();

	cam:move_to(v(0.55, 2500, -283.68), v(1.46, 2593, -67), 3);

	cam_outro:fade(false, 2);

	local outro_units_hidden = false;
		
	local cutscene_outro = cutscene:new(
		"cutscene_outro", 						-- unique string name for cutscene
		ga_player_01.sunits,					-- unitcontroller over player's army
		6000, 									-- duration of cutscene in ms
		function() end_outro_cutscene() end		-- what to call when cutscene is finished
	);

	-- skip callback
	cutscene_outro:set_skippable(
		true, 
		function()
			local cam_outro = bm:camera();
			cam_outro:fade(true, 0);
			bm:stop_cindy_playback(true);
			
			if outro_units_hidden then
				ga_player_01.sunits:set_enabled(false)
				ga_player_02.sunits:set_enabled(false)
			end;

			bm:callback(function() cam:fade(false, 0.5) end, 1000);
		end
	);

	-- set up actions on cutscene
	cutscene_outro:action(function() cam:fade(true, 0.5) end, 6000); --6s

	-- cutscene_outro:action(function() cutscene_outro:play_sound(wh3_outro_sfx_00) end, 100);

	--cutscene_outro:set_music("Final_Battle_Outro", 0, 0)

	cutscene_outro:start();
end;

function end_outro_cutscene()
	gb.sm:trigger_message("outro_cutscene_end")
	bm:change_victory_countdown_limit(0)
	bm:notify_survival_completion()
	cam:fade(false, 2)
	bm:hide_subtitles()
end;

-------------------------------------------------------------------------------------------------
------------------------------------------ARMY TELEPORT------------------------------------------
-------------------------------------------------------------------------------------------------

function teleport_boss()
	bm:out("\tteleport_boss() called");
	
	ga_ai_att_04.sunits:item(1).uc:teleport_to_location(v(-10, -469), 0, 4.5);

end;

gb.sm:add_listener("teleport_archaon", function() teleport_boss() end)

-------------------------------------------------------------------------------------------------
--------------------------------------------CUTSCENES--------------------------------------------
-------------------------------------------------------------------------------------------------

gb.sm:add_listener("prepare_reveal", function() prepare_for_reveal_cutscene() end);
gb.sm:add_listener("prepare_outro", function() prepare_for_outro_cutscene() end);

gb:stop_terrain_composite_scene_on_message("prepare_outro", altar_capture);
gb:start_terrain_composite_scene_on_message("prepare_outro", altar_capture, 3500);

-------------------------------------------------------------------------------------------------
----------------------------------------------SETUP----------------------------------------------
-------------------------------------------------------------------------------------------------

gb:message_on_time_offset("battle_start", 10);

local perpetual = true;
local shattered_only = false;
local permit_rampaging = true;

ga_player_01.sunits:set_always_visible_no_hidden_no_leave_battle(true);
ga_player_01.sunits:release_control();
ga_ai_def_01.sunits:set_always_visible_no_hidden_no_leave_battle(true);

show_attack_closest_unit_debug_output = true;

-------DEFENDER 1-------
ga_ai_def_01:defend_on_message("battle_start" , 0, -150, 150); 
ga_ai_def_01:message_on_casualties("def_01_attack", 0.025);
gb:message_on_time_offset("def_01_attack", 60000, "battle_start");	-- if player doesn't attack after a minute, go get em
ga_ai_def_01:attack_on_message("def_01_attack");


-------Gates-------
ga_player_01:enable_map_barrier_on_message("ready_ai_wave_03", "map_barrier_N", false);
ga_player_01:enable_map_barrier_on_message("ready_ai_wave_03", "map_barrier_S", false);
ga_player_01:enable_map_barrier_on_message("ready_ai_wave_03", "map_barrier_E", false);
ga_player_01:enable_map_barrier_on_message("ready_ai_wave_03", "map_barrier_W", false);

-------------------------------------------------------------------------------------------------
---------------------------------------------WAVE 1----------------------------------------------
-------------------------------------------------------------------------------------------------

gb:message_on_time_offset("ai_wave_01", 10000, "cp_1_1_owned");
gb:message_on_time_offset("ai_wave_01", 10000, "cp_1_2_owned");		-- careful this cant get triggered out of sync later on?
gb:message_on_time_offset("ai_wave_01_offset", 2500, "ai_wave_01");
gb:message_on_all_messages_received("ready_ai_wave_02", "wave_01_1_defeated", "wave_01_2_defeated")

-- Nurgle’s maggots approach. They dare try to claim what is mine! I best disabuse them of this notion.
gb:play_sound_on_message("ai_wave_01_offset", wh3_wave_sfx_01, nil, 500, nil, 500)

-----ARMY1-----
ga_ai_att_01_1:add_to_survival_battle_wave_on_message("ai_wave_01", 0, false);
ga_ai_att_01_1:message_on_any_deployed("1_1_in");
ga_ai_att_01_1:rush_on_message("1_1_in");
ga_ai_att_01_1:message_on_rout_proportion("wave_01_1_defeated", 0.99, permit_rampaging);
ga_ai_att_01_1:rout_over_time_on_message("ready_ai_wave_02", 3000);
ga_ai_att_01_1:deploy_at_random_intervals_on_message(
	"ai_wave_01", 				-- message
	1, 							-- min units
	1, 							-- max units
	2000, 						-- min period
	2000, 						-- max period
	nil,				 		-- cancel message
	nil,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

gb:add_listener(
	"1_1_in",
	function()
		ga_ai_att_01_1.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_ai_att_01_1.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	end
);

-----ARMY2-----
ga_ai_att_01_2:add_to_survival_battle_wave_on_message("ai_wave_01", 0, false);
ga_ai_att_01_2:message_on_any_deployed("1_2_in");
ga_ai_att_01_2:rush_on_message("1_2_in");
ga_ai_att_01_2:message_on_rout_proportion("wave_01_2_defeated", 0.99, permit_rampaging);
ga_ai_att_01_2:rout_over_time_on_message("ready_ai_wave_02", 3000);
ga_ai_att_01_2:deploy_at_random_intervals_on_message(
	"ai_wave_01_offset", 		-- message
	1, 							-- min units
	1, 							-- max units
	2000, 						-- min period
	2000, 						-- max period
	nil,				 		-- cancel message
	nil,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

gb:add_listener(
	"1_2_in",
	function()
		ga_ai_att_01_2.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_ai_att_01_2.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	end
);

-------------------------------------------------------------------------------------------------
---------------------------------------------WAVE 2----------------------------------------------
-------------------------------------------------------------------------------------------------

gb:message_on_time_offset("ai_wave_02", 10000, "cp_2_1_owned");
gb:message_on_time_offset("ai_wave_02", 10000, "cp_2_2_owned");
gb:message_on_time_offset("ai_wave_02_offset", 3000, "ai_wave_02");
gb:message_on_all_messages_received("ready_ai_wave_03", "wave_02_1_defeated", "wave_02_2_defeated");

-- Finally, Tzeentch’s machinations reveal themselves. They will not stop me! It is my right to feel the Dark Prince’s caress!
gb:play_sound_on_message("ai_wave_02_offset", wh3_wave_sfx_02, nil, 500, nil, 500)

-----ARMY1-----
ga_ai_att_02_1:add_to_survival_battle_wave_on_message("ai_wave_02", 1, false);
ga_ai_att_02_1:message_on_any_deployed("2_1_in");
ga_ai_att_02_1:rush_on_message("2_1_in");
ga_ai_att_02_1:message_on_rout_proportion("wave_02_1_defeated", 0.99, permit_rampaging);
ga_ai_att_02_1:deploy_at_random_intervals_on_message(
	"ai_wave_02", 				-- message
	1, 							-- min units
	1, 							-- max units
	3000, 						-- min period
	3000, 						-- max period
	nil,				 		-- cancel message
	nil,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

gb:add_listener(
	"2_1_in",
	function()
		ga_ai_att_02_1.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_ai_att_02_1.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	end
);

-----ARMY2-----
ga_ai_att_02_2:add_to_survival_battle_wave_on_message("ai_wave_02", 1, false);
ga_ai_att_02_2:message_on_any_deployed("2_2_in");
ga_ai_att_02_2:rush_on_message("2_2_in");
ga_ai_att_02_2:message_on_rout_proportion("wave_02_2_defeated", 0.99, permit_rampaging);
ga_ai_att_02_2:deploy_at_random_intervals_on_message(
	"ai_wave_02_offset", 		-- message
	1, 							-- min units
	1, 							-- max units
	3000, 						-- min period
	3000, 						-- max period
	nil,				 		-- cancel message
	nil,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

gb:add_listener(
	"2_2_in",
	function()
		ga_ai_att_02_2.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_ai_att_02_2.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	end
);

-------------------------------------------------------------------------------------------------
---------------------------------------WAVE 3 - BOSS---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:message_on_time_offset("prepare_reveal", 15000, "cp_3_owned");
gb:message_on_time_offset("boss_time", 100, "reveal_cutscene_end");
gb:message_on_time_offset("boss_time_offset_1", 4000, "boss_time");
gb:message_on_time_offset("boss_time_offset_2", 4000, "boss_time_offset_1");
gb:message_on_time_offset("boss_time_offset_3", 4000, "boss_time_offset_2");
gb:message_on_time_offset("prepare_outro", 10000, "prepare_for_outro");
gb:message_on_all_messages_received("prepare_for_outro", "wave_03_1_defeated", "wave_03_2_defeated", "wave_03_3_defeated", "boss_defeated", "boss_helpers_defeated")

-----ARMY1-----
ga_ai_att_03_1:add_to_survival_battle_wave_on_message("reveal_cutscene_end", 2, true);
ga_ai_att_03_1:message_on_any_deployed("3_1_in");
ga_ai_att_03_1:rush_on_message("3_1_in");
ga_ai_att_03_1:message_on_rout_proportion("wave_03_1_defeated", 0.99);
ga_ai_att_03_1:rout_over_time_on_message("prepare_for_outro", 3000);
ga_ai_att_03_1:deploy_at_random_intervals_on_message(
	"boss_time_offset_1", 				-- message
	1, 							-- min units
	1, 							-- max units
	10000, 						-- min period
	10000, 						-- max period
	nil,				 		-- cancel message
	nil,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

gb:add_listener(
	"3_1_in",
	function()
		ga_ai_att_03_1.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_ai_att_03_1.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	end
);

-----ARMY2-----
ga_ai_att_03_2:add_to_survival_battle_wave_on_message("reveal_cutscene_end", 2, true);
ga_ai_att_03_2:message_on_any_deployed("3_2_in");
ga_ai_att_03_2:rush_on_message("3_2_in");
ga_ai_att_03_2:message_on_rout_proportion("wave_03_2_defeated", 0.99);
ga_ai_att_03_2:rout_over_time_on_message("prepare_for_outro", 3000);
ga_ai_att_03_2:deploy_at_random_intervals_on_message(
	"boss_time_offset_2", 		-- message
	1, 							-- min units
	1, 							-- max units
	10000, 						-- min period
	10000, 						-- max period
	nil,				 		-- cancel message
	nil,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

gb:add_listener(
	"3_2_in",
	function()
		ga_ai_att_03_2.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_ai_att_03_2.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	end
);

-----ARMY3-----
ga_ai_att_03_3:add_to_survival_battle_wave_on_message("reveal_cutscene_end", 2, false);
ga_ai_att_03_3:message_on_any_deployed("3_3_in");
ga_ai_att_03_3:rush_on_message("3_3_in");
ga_ai_att_03_3:message_on_rout_proportion("wave_03_3_defeated", 0.99, permit_rampaging);	-- permit rampaging needed here?
ga_ai_att_03_3:rout_over_time_on_message("prepare_for_outro", 3000);
ga_ai_att_03_3:deploy_at_random_intervals_on_message(
	"boss_time_offset_3", 		-- message
	1, 							-- min units
	1, 							-- max units
	10000, 						-- min period
	10000, 						-- max period
	nil,				 		-- cancel message
	nil,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

gb:add_listener(
	"3_3_in",
	function()
		ga_ai_att_03_3.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_ai_att_03_3.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	end
);

-------------------------------------------------------------------------------------------------
-------------------------------------------BOSS MAN--------------------------------------------
-------------------------------------------------------------------------------------------------

ga_ai_att_04:reinforce_on_message("reveal_cutscene_end", 100);
--ga_ai_att_04:add_to_survival_battle_wave_on_message("reveal_cutscene_end", 2, true);
ga_ai_att_04:message_on_any_deployed("4_in");
ga_ai_att_04:set_invincible_on_message("4_in", true);
ga_ai_att_04:set_invincible_on_message("boss_is_gonna_get_ya", false);
gb:message_on_time_offset("boss_is_gonna_get_ya", 25000, "5_in");		-- waits a bit for his backup before charging in
ga_ai_att_04:rush_on_message("boss_is_gonna_get_ya");
ga_ai_att_04:add_winds_of_magic_on_message("boss_is_gonna_get_ya", 50)	-- give em a little extra spice
ga_ai_att_04:message_on_rout_proportion("boss_defeated", 1.0, permit_rampaging);
ga_ai_att_04:rout_over_time_on_message("prepare_for_outro", 1000);

gb:add_listener(
	"boss_time",
	function()
		-- delay call by .1 second
		bm:callback(
			function()
				--ga_ai_att_04.sunits:set_enabled(true);		-- not needed as he is not disabled prior
				ga_ai_att_04.sunits:set_always_visible_no_hidden_no_leave_battle(true);	
				bm:add_survival_battle_wave(2, ga_ai_att_04.sunits, true);
			end,
			100
		);
	end
);

ga_ai_att_05:add_to_survival_battle_wave_on_message("reveal_cutscene_end", 2, true);
ga_ai_att_05:message_on_any_deployed("5_in");
ga_ai_att_05:rush_on_message("5_in");
ga_ai_att_05:message_on_rout_proportion("boss_helpers_defeated", 0.99);
ga_ai_att_05:rout_over_time_on_message("prepare_for_outro", 1000);
ga_ai_att_05:deploy_at_random_intervals_on_message(
	"boss_time", 				-- message
	4, 							-- min units
	4, 							-- max units
	500, 						-- min period
	1000, 						-- max period
	nil,				 		-- cancel message
	nil,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

gb:add_listener(
	"4_in",
	function()
		ga_ai_att_04.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	end
);

gb:add_listener(
	"5_in",
	function()
		ga_ai_att_05.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_ai_att_05.sunits:set_always_visible_no_leave_battle(true);
	end
);

gb:add_listener(
	"prepare_for_outro",
	function()
		if ga_ai_att_05.sunits:are_any_active_on_battlefield() == true then
			ga_ai_att_05.sunits:kill_proportion_over_time(1.0, 100, false);				-- might add waves 3_x to this?
		end;
	end,
	true
);


-------------------------------------------------------------------------------------------------
-------------------------------------------OBJECTIVES--------------------------------------------
-------------------------------------------------------------------------------------------------

gb:add_listener(
	"obj_01",
	function()
		bm:set_locatable_objective(
			"wh3_dlc20_survival_point_chs_1_1", 
			v(-191.59, 2577.98, -196.24), 
			v(-78.16, 2441.39, -77.66), 
			1, 
			true
		);
	end
);

gb:add_listener(
	"obj_01_2",
	function()
		bm:set_locatable_objective(
			"wh3_dlc20_survival_point_chs_1_2", 
			v(200.40, 2580.77, -197.85), 
			v(87.23, 2438.85, -85.44), 
			1, 
			true
		);
	end
);

gb:complete_objective_on_message("cp_1_1_owned", "wh3_dlc20_survival_point_chs_1_1", 1000);
gb:complete_objective_on_message("cp_1_2_owned", "wh3_dlc20_survival_point_chs_1_2", 1000);
gb:remove_objective_on_message("1_1_deployed", "wh3_dlc20_survival_point_chs_1_1", 1000);
gb:remove_objective_on_message("1_1_deployed", "wh3_dlc20_survival_point_chs_1_2", 1000);

gb:add_listener(
	"obj_02",
	function()
		bm:set_locatable_objective(
			"wh3_dlc20_survival_point_chs_2_1", 
			v(-199.23, 2582.16, 198.77), 
			v(-79.41, 2450.64, 81.16), 
			1, 
			true
		);
	end
);

gb:add_listener(
	"obj_02_2",
	function()
		bm:set_locatable_objective(
			"wh3_dlc20_survival_point_chs_2_2", 
			v(200.98, 2579.60, 202.97), 
			v(83.86, 2449.86, 80.75), 
			1, 
			true
		);
	end
);

gb:complete_objective_on_message("cp_2_1_owned", "wh3_dlc20_survival_point_chs_2_1", 1000);
gb:complete_objective_on_message("cp_2_2_owned", "wh3_dlc20_survival_point_chs_2_2", 1000);
gb:remove_objective_on_message("2_1_deployed", "wh3_dlc20_survival_point_chs_2_1", 1000);
gb:remove_objective_on_message("2_1_deployed", "wh3_dlc20_survival_point_chs_2_2", 1000);

gb:add_listener(
	"obj_03",
	function()
		bm:set_locatable_objective(
			"wh3_dlc20_survival_point_chs_altar", 
			v(-76.34, 2597.75, 156.52),
			v(-2.99, 2476.19, -2.64),
			1, 
			true
		);
	end
);

gb:complete_objective_on_message("cp_3_owned", "wh3_dlc20_survival_point_chs_altar", 1000);
gb:remove_objective_on_message("4_deployed", "wh3_dlc20_survival_point_chs_altar", 1000);

--gb:set_objective_with_leader_on_message("outro_cutscene_end", "wh3_dlc20_survival_altar_of_battle_boss_archaon", 1000);
--gb:complete_objective_on_message("prepare_for_outro", "wh3_dlc20_survival_altar_of_battle_boss_archaon", 1000);

gb:message_on_time_offset("obj_01", 3000, "battle_start");
gb:message_on_time_offset("obj_01_2", 6000, "battle_start");
gb:message_on_time_offset("obj_02", 3000, "ready_ai_wave_02");
gb:message_on_time_offset("obj_02_2", 6000, "ready_ai_wave_02");
gb:message_on_time_offset("obj_03", 3000, "ready_ai_wave_03");

-- At last - the Altar is mine to defile!
gb:play_sound_on_message("ready_ai_wave_03", wh3_wave_sfx_03, nil, 500, nil, 500)

gb:set_objective_with_leader_on_message("1_1_deployed", "wh3_dlc20_survival_altar_of_battle_wave_festus", 1000);
gb:complete_objective_on_message("ready_ai_wave_02", "wh3_dlc20_survival_altar_of_battle_wave_festus", 1000);
gb:remove_objective_on_message("obj_02", "wh3_dlc20_survival_altar_of_battle_wave_festus", 1000);

gb:set_objective_with_leader_on_message("2_1_deployed", "wh3_dlc20_survival_altar_of_battle_wave_vilitch", 1000);
gb:complete_objective_on_message("ready_ai_wave_03", "wh3_dlc20_survival_altar_of_battle_wave_vilitch", 1000);
gb:remove_objective_on_message("obj_03", "wh3_dlc20_survival_altar_of_battle_wave_vilitch", 1000);

--gb:set_objective_with_leader_on_message("3_1_deployed", "wh3_dlc20_survival_altar_of_battle_boss_archaon", 1000);			-- hmm
--gb:complete_objective_on_message("prepare_for_outro", "wh3_dlc20_survival_altar_of_battle_boss_archaon", 1000);
--gb:remove_objective_on_message("prepare_for_outro", "wh3_dlc20_survival_altar_of_battle_boss_archaon", 1000);

gb:add_listener(
	"boss_time",
	function()
		if ga_ai_att_04.sunits:are_any_active_on_battlefield() == true then
			bm:set_objective_with_leader("wh3_dlc20_survival_altar_of_battle_boss_archaon");		---hhhmmmm
		end;
	end,
	true
);

gb:complete_objective_on_message("prepare_for_outro", "wh3_dlc20_survival_altar_of_battle_boss_archaon", 1000);

---------------
-----WAVES-----
---------------

core:add_listener(
	"waves_defeated",
	"ScriptEventSurvivalBattleWaveDefeated",
	true,
	function(context)
		local index = context:index();
		if index == 0 then
			gb.sm:trigger_message("wave_01_defeated");
		elseif index == 1 then
			gb.sm:trigger_message("wave_02_defeated");
		elseif index == 2 then
			gb.sm:trigger_message("wave_03_defeated");
		end;
	end,
	true
);

gb:add_listener(
	"outro_cutscene_end",
	function()
		-- delay call by 1 second
		bm:callback(
			function()
				bm:end_battle()
				cam:fade(true, 1.0)
				bm:change_victory_countdown_limit(0)
				bm:notify_survival_completion()
			end,
			3000
		);
	end
);

---------------------------------------------
-----------------OUTRO TEXTS-----------------
---------------------------------------------

ga_player_01:message_on_victory("player_wins");
ga_player_01:message_on_defeat("player_loses");

loading_screen_key_defeat = "wh3_dlc20_survival_altar_of_battle_outro";		-- update this

sm:add_listener(
	"player_loses",
	function()
		core:add_listener(
			"set_loading_screen",
			"ComponentLClickUp",
			function(context)
				return context.string == "button_dismiss_results";
			end,
			function()
				common.set_custom_loading_screen_key(loading_screen_key_defeat);
			end,
			false
		);
	end
);

loading_screen_win = "wh3_dlc20_survival_altar_of_battle_outro";

sm:add_listener(
	"player_wins",
	function()
		core:add_listener(
			"set_loading_screen",
			"ComponentLClickUp",
			function(context)
				return context.string == "button_dismiss_results";
			end,
			function()
				common.set_custom_loading_screen_key(loading_screen_win);
			end,
			false
		);
	end
);

---------------------------------------------
--------------------DEBUG--------------------
---------------------------------------------

core:add_listener(
	"skip_wave_listener",
	"ComponentLClickUp",
	function(context)
		return context.string == "dev_button_skip_wave";
	end,
	function()
		if ga_ai_att_01_1.sunits:are_any_active_on_battlefield() == true then
			ga_ai_att_01_1.sunits:rout_over_time(1000);
			ga_ai_att_01_1.sunits:cancel_deploy_at_random_intervals();
			ga_ai_att_01_2.sunits:rout_over_time(1000);
			ga_ai_att_01_2.sunits:cancel_deploy_at_random_intervals();
		elseif ga_ai_att_02_1.sunits:are_any_active_on_battlefield() == true then
			ga_ai_att_02_1.sunits:rout_over_time(1000);
			ga_ai_att_02_1.sunits:cancel_deploy_at_random_intervals();
			ga_ai_att_02_2.sunits:rout_over_time(1000);
			ga_ai_att_02_2.sunits:cancel_deploy_at_random_intervals();
		elseif ga_ai_att_03_1.sunits:are_any_active_on_battlefield() == true then
			ga_ai_att_03_1.sunits:rout_over_time(1000);
			ga_ai_att_03_1.sunits:cancel_deploy_at_random_intervals();
			ga_ai_att_03_2.sunits:rout_over_time(1000);
			ga_ai_att_03_2.sunits:cancel_deploy_at_random_intervals();
			ga_ai_att_03_3.sunits:rout_over_time(1000);
			ga_ai_att_03_3.sunits:cancel_deploy_at_random_intervals();
			ga_ai_att_04.sunits:rout_over_time(1000);
			ga_ai_att_04.sunits:cancel_deploy_at_random_intervals();
			ga_ai_att_05.sunits:rout_over_time(1000);
			ga_ai_att_05.sunits:cancel_deploy_at_random_intervals();
		end;
	end,
	true
);

-- line to quickly debug archaon reveal cutscene, DO NOT SUBMIT with this enabled!
--gb:message_on_time_offset("prepare_reveal", 5000, "battle_start");