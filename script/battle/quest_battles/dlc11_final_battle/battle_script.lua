load_script_libraries();

-- include shared script 
local file_name, file_path = get_file_name_and_path();
package.path = file_path .. "/?.lua;" .. package.path;

bm:camera():fade(true, 0);

gb = generated_battle:new(
	true,                                      		    -- screen starts black
	false,                                      		-- prevent deployment for player
	true,                                      		    -- prevent deployment for ai
	function() end_deployment_phase() end,          	-- intro cutscene function
	false                                      			-- debug mode
);

--preload stuttering fix
intro_cinematic_file = "script\\battle\\quest_battles\\_cutscene\\managers\\bet.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);
local sm = get_messager();

-------ARMY SETUP-------
ga_player_01 = gb:get_army(gb:get_player_alliance_num(), 1);	
ga_player_ally=gb:get_army(gb:get_player_alliance_num(), 1, "reinf");

ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(1), 1);
-- ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(1), 2,"base_left");
-- ga_ai_02_2 = gb:get_army(gb:get_non_player_alliance_num(1), 3,"base_right");
-- ga_ai_03 = gb:get_army(gb:get_non_player_alliance_num(1), 4,"special");
-- ga_ai_04 = gb:get_army(gb:get_non_player_alliance_num(1), 5); 

if gb:get_army(gb:get_non_player_alliance_num(), 1):get_script_name() == "base_left" then
	ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(1), 1,"base_left");
elseif gb:get_army(gb:get_non_player_alliance_num(), 2):get_script_name() == "base_left" then
	ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(1), 2,"base_left");
elseif gb:get_army(gb:get_non_player_alliance_num(), 3):get_script_name() == "base_left" then
	ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(1), 3,"base_left");
elseif gb:get_army(gb:get_non_player_alliance_num(), 4):get_script_name() == "base_left" then
	ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(1), 4,"base_left");
elseif gb:get_army(gb:get_non_player_alliance_num(), 5):get_script_name() == "base_left" then
	ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(1), 5,"base_left");
end

if gb:get_army(gb:get_non_player_alliance_num(), 1):get_script_name() == "base_right" then
	ga_ai_02_2 = gb:get_army(gb:get_non_player_alliance_num(1), 1,"base_right");
elseif gb:get_army(gb:get_non_player_alliance_num(), 2):get_script_name() == "base_right" then
	ga_ai_02_2 = gb:get_army(gb:get_non_player_alliance_num(1), 2,"base_right");
elseif gb:get_army(gb:get_non_player_alliance_num(), 3):get_script_name() == "base_right" then
	ga_ai_02_2 = gb:get_army(gb:get_non_player_alliance_num(1), 3,"base_right");
elseif gb:get_army(gb:get_non_player_alliance_num(), 4):get_script_name() == "base_right" then
	ga_ai_02_2 = gb:get_army(gb:get_non_player_alliance_num(1), 4,"base_right");
elseif gb:get_army(gb:get_non_player_alliance_num(), 5):get_script_name() == "base_right" then
	ga_ai_02_2 = gb:get_army(gb:get_non_player_alliance_num(1), 5,"base_right");
end

if gb:get_army(gb:get_non_player_alliance_num(), 2):get_script_name() == "" then
	ga_ai_04 = gb:get_army(gb:get_non_player_alliance_num(1), 2);
elseif gb:get_army(gb:get_non_player_alliance_num(), 3):get_script_name() == "" then
	ga_ai_04 = gb:get_army(gb:get_non_player_alliance_num(1), 3);
elseif gb:get_army(gb:get_non_player_alliance_num(), 4):get_script_name() == "" then
	ga_ai_04 = gb:get_army(gb:get_non_player_alliance_num(1), 4);
elseif gb:get_army(gb:get_non_player_alliance_num(), 5):get_script_name() == "" then
	ga_ai_04 = gb:get_army(gb:get_non_player_alliance_num(1), 5);
end

if gb:get_army(gb:get_non_player_alliance_num(), 1):get_script_name() == "special" then
	ga_ai_03 = gb:get_army(gb:get_non_player_alliance_num(1), 1,"special");
elseif gb:get_army(gb:get_non_player_alliance_num(), 2):get_script_name() == "special" then
	ga_ai_03 = gb:get_army(gb:get_non_player_alliance_num(1), 2,"special");
elseif gb:get_army(gb:get_non_player_alliance_num(), 3):get_script_name() == "special" then
	ga_ai_03 = gb:get_army(gb:get_non_player_alliance_num(1), 3,"special");
elseif gb:get_army(gb:get_non_player_alliance_num(), 4):get_script_name() == "special" then
	ga_ai_03 = gb:get_army(gb:get_non_player_alliance_num(1), 4,"special");
elseif gb:get_army(gb:get_non_player_alliance_num(), 5):get_script_name() == "special" then
	ga_ai_03 = gb:get_army(gb:get_non_player_alliance_num(1), 5,"special");
end

ga_ai_01.sunits:change_behaviour_active("fire_at_will", false);
ga_player_01.sunits:change_behaviour_active("fire_at_will", false);
ga_ai_01:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true);
ga_player_01:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true);

-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

wh2_main_sfx_01 = new_sfx("Play_wh2_dlc11_lokhir_fellheart_vc_final_battle_pt_01");
wh2_main_sfx_02 = new_sfx("Play_wh2_dlc11_lokhir_fellheart_vc_final_battle_pt_02");
wh2_main_sfx_03 = new_sfx("Play_wh2_dlc11_lokhir_fellheart_vc_final_battle_pt_03");
wh2_main_sfx_04 = new_sfx("Play_wh2_dlc11_lokhir_fellheart_vc_final_battle_pt_04");
wh2_main_sfx_05 = new_sfx("Play_wh2_dlc11_lokhir_fellheart_vc_final_battle_pt_05");
wh2_main_sfx = new_sfx("Play_Movie_DLC11_Final_Quest_Battle_Intro_Sweetener");

composite_a_1 = "composite_scene/seamonster/merwyrm_swimstraight_01.csc";
composite_a_2 = "composite_scene/seamonster/merwyrm_swimstraight_02.csc";
composite_a_3 = "composite_scene/seamonster/merwyrm_swimstraight_03.csc";
composite_a_4 = "composite_scene/seamonster/merwyrm_swimstraight_04.csc";
composite_b_1 = "composite_scene/seamonster/merwyrm_overmap_01.csc";
composite_b_2 = "composite_scene/seamonster/merwyrm_overmap_02.csc";
composite_b_3 = "composite_scene/seamonster/merwyrm_overmap_03.csc";
composite_d = "composite_scene/seamonster/merwyrm_introroar_01.csc";
composite_c_1 = "composite_scene/seamonster/merwyrm_roar_01.csc";
composite_c_2 = "composite_scene/seamonster/merwyrm_roar_02.csc";

-------------------------------------------------------------------------------------------------
------------------------------------------- CUTSCENE --------------------------------------------
-------------------------------------------------------------------------------------------------

function end_deployment_phase()
	bm:out("\tend_deployment_phase() called");
		
	local cam = bm:camera();
	
	-- REMOVE ME
	cam:fade(true, 0);
	
	-- declare cutscene
	local cutscene_intro = cutscene:new(
		"cutscene_intro", 						-- unique string name for cutscene
		ga_player_01.sunits,					-- unitcontroller over player's army
		70000, 									-- duration of cutscene in ms
		function() intro_cutscene_end() end		-- what to call when cutscene is finished
	);
	
	local player_units_hidden = false;
	
	-- set up subtitles
	local subtitles = cutscene_intro:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();
	
	-- cutscene_intro:set_post_cutscene_fade_time(0);
	
	-- skip callback
	cutscene_intro:set_skippable(
		true, 
		function()
			local cam = bm:camera();
			cam:fade(true, 0);
			bm:stop_cindy_playback(true);
			
			if player_units_hidden then
				ga_player_01:set_enabled(true)
			end;
						
			bm:callback(function() cam:fade(false, 0.5) end, 500);
		end
	);
	
	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(false, 1) end, 1000);
	
	-- cutscene_intro:action(function() cam:move_to(v(-781.747, 84.081, 5.09), v(-770.503, 81.635, 21.587), 0, false, 30) end, 0);	

	cutscene_intro:action(function() bm:cindy_playback("script\\battle\\quest_battles\\_cutscene\\managers\\tbp.CindySceneManager", true) end, 200);
	
	cutscene_intro:action(
		function()
			local t1 = 28000;
			local t2 = 25000;
			local t3 = 23000;
			local t4 = 23000;
			local t5 = 100;
			bm:callback(function()
					bm:start_terrain_composite_scene(composite_b_1, nil, 0); 
					end, 
					t1 + t2, 
					"Merwyrm_loop");
			bm:callback(function()
					bm:stop_terrain_composite_scene(composite_b_1);
					end, 
					t1 + t2 + t3, 
					"Merwyrm_loop");	
			bm:callback(function()
					bm:start_terrain_composite_scene(composite_b_3, nil, 0); 
					end, 
					t5, 
					"Merwyrm_loop");
			bm:callback(function()
					bm:stop_terrain_composite_scene(composite_b_3);
					end, 
					t5 + t3, 
					"Merwyrm_loop");				
		end, 
		200
	);	
	-- cutscene_intro:action(
		-- function() 
			-- player_units_hidden = false;
			-- ga_player:set_enabled(true) 
		-- end, 
		-- 45000
	-- );		
	
	-- Voiceover and Subtitles --
	local t_0 = 3000;
	local t_1 = 15000;
	local t_2 = 14000;
	local t_3 = 8000;
	local t_4 = 13000;
	local t_5 = 3000;
	local t_margin = 300;
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx) end, 100);	
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_01) end, t_0);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc11_Lokhir_Fellheart_VC_Final_Battle_pt_01", "subtitle_with_frame", 14)	end, t_0);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, t_0+t_1);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_02) end, t_0+t_1+t_margin);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc11_Lokhir_Fellheart_VC_Final_Battle_pt_02", "subtitle_with_frame", 13)	end, t_0+t_1+t_margin);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, t_0+t_1+t_2+t_margin);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_03) end, t_0+t_1+t_2+t_margin*2);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc11_Lokhir_Fellheart_VC_Final_Battle_pt_03", "subtitle_with_frame", 8)	end, t_0+t_1+t_2+t_margin*2);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, t_0+t_1+t_2+t_3+t_margin*2);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_04) end, t_0+t_1+t_2+t_3+t_margin*3);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc11_Lokhir_Fellheart_VC_Final_Battle_pt_04", "subtitle_with_frame", 4)	end, t_0+t_1+t_2+t_3+t_margin*3);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, t_0+t_1+t_2+t_3+t_4+t_margin*3);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_05) end, t_0+t_1+t_2+t_3+t_4+t_margin*4);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc11_Lokhir_Fellheart_VC_Final_Battle_pt_05", "subtitle_with_frame", 3)	end, t_0+t_1+t_2+t_3+t_4+t_margin*4);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, t_0+t_1+t_2+t_3+t_4+t_5+t_margin*4);
	
	cutscene_intro:start();
end;

function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end");
end;



---------------------------
----HARD SCRIPT VERSION----
---------------------------
--gb:set_objective_on_message("deployment_started", "wh_main_qb_objective_kill_enemy_general");



-- if gb:get_army(gb:get_non_player_alliance_num(), 2):get_script_name() == "side" then
	-- ga_ai_04 = gb:get_army(gb:get_non_player_alliance_num(), 2);
-- elseif gb:get_army(gb:get_non_player_alliance_num(), 3):get_script_name() == "side" then
	-- ga_ai_04 = gb:get_army(gb:get_non_player_alliance_num(), 3);
-- else 
	-- ga_ai_04 = gb:get_army(gb:get_non_player_alliance_num(), 4);
-- end


-------OBJECTIVES-------
--gb:queue_help_on_message("battle_started", "wh_dlc05_qb_wef_mini_silver_spire_hint_objective");

gb:set_objective_on_message("battle_started", "wh2_dlc11_qb_cst_final_battle_hint_objective");
gb:remove_objective_on_message("survival_on", "wh2_dlc11_qb_cst_final_battle_hint_objective");
gb:set_objective_on_message("survival_on", "wh2_dlc11_qb_cst_final_battle_special_wave_arrive");
gb:set_objective_on_message("warn_fellheart", "wh2_dlc11_qb_cst_final_battle_objective_back_attack");
gb:remove_objective_on_message("all_waves_gone", "wh2_dlc11_qb_cst_final_battle_special_wave_arrive");
gb:set_objective_on_message("all_waves_gone", "wh2_dlc11_qb_cst_final_battle_main_objective");
gb:remove_objective_on_message("all_waves_gone", "wh2_dlc11_qb_cst_final_battle_hold_against_enemy_count");
gb:remove_objective_on_message("all_waves_gone", "wh2_dlc11_qb_cst_final_battle_objective_back_attack");

gb:queue_help_on_message("survival_on", "wh2_dlc11_qb_cst_final_battle_enemy_coming",10000,1000);
--gb:queue_help_on_message("strong_in", "wh2_dlc11_qb_cst_final_battle_hint_survival_deadly",10000,1000);
gb:queue_help_on_message("warn_fellheart", "wh2_dlc11_qb_cst_final_battle_hint_back_attack",10000,1000);
gb:queue_help_on_message("all_waves_gone", "wh2_dlc11_qb_cst_final_battle_hint_fellheart",10000,1000);


get_messager():add_listener(
	"survival_on",
	function()
		local loop_func = function()
			bm:out("*** Starting total countdown");
			
			
			for i = 12, 1, -1 do
				bm:callback(function() bm:set_objective("wh2_dlc11_qb_cst_final_battle_hold_against_enemy_count", i) end, (12 - i) * 60000, "Main_countdown_loop");
			end;
			
			
			-- remove above objective
			bm:callback(function() bm:remove_objective("wh2_dlc11_qb_cst_final_battle_hold_against_enemy_count") end, 720000, "Main_countdown_loop");
			
			bm:callback(function() bm:set_objective("wh2_dlc11_qb_cst_final_battle_main_objective", i) end, 720000, "Main_countdown_loop");

		
		
		end;
		
		-- call first loop
		loop_func();
	
		-- call for subsequent loops
		bm:callback(function()
				gb.sm:trigger_message("all_waves_gone");
				end, 
				750000, 
				"Merwyrm_loop");
				
		bm:callback(function()
				gb.sm:trigger_message("warn_fellheart");
				end, 
				720000, 
				"Merwyrm_loop");

	end
);

function compo_call(scene, t0, t1)
	bm:callback(function()
					bm:start_terrain_composite_scene(scene, nil, 0); 
				end, 
		t0, 
		"Merwyrm_loop");	
	bm:callback(function()
					bm:stop_terrain_composite_scene(scene); 
				end, 
		t0+t1, 
		"Merwyrm_loop");
end

get_messager():add_listener(
	"01_intro_cutscene_end",
	function()
		
		local cycle_1 = 24000;
		local cycle_2 = 24000;
		local cycle_3 = 24000;
		local margin = 5000;
		local start = 5000;
		local total_length = start + cycle_1*8 + cycle_2*2 + cycle_3*3+ margin;
		
		local loop_func = function()
			bm:out("*** Starting compo countdown");
				
			for i = total_length/1000, 1, -1 do
				if i == start/1000 then
					--start composite_a_1
					--gb:start_terrain_composite_scene_on_message("battle_started", beam_stage_1, 20000);	
					--swim cycle one
					compo_call(composite_a_1, i * 1000, cycle_1)
					compo_call(composite_a_2, i * 1000 + 1*cycle_1, cycle_1)
					compo_call(composite_c_2, i * 1000 + 2*cycle_1, cycle_3)
					compo_call(composite_a_4, i * 1000 + 2*cycle_1 + 1*cycle_3, cycle_1)
					compo_call(composite_b_1, i * 1000 + 3*cycle_1 + 1*cycle_3, cycle_2)
					compo_call(composite_a_3, i * 1000 + 3*cycle_1 + 1*cycle_3 + 1*cycle_2, cycle_1)
					compo_call(composite_a_4, i * 1000 + 4*cycle_1 + 1*cycle_3 + 1*cycle_2, cycle_1)
					compo_call(composite_c_1, i * 1000 + 5*cycle_1 + 1*cycle_3 + 1*cycle_2, cycle_3)
					compo_call(composite_a_2, i * 1000 + 5*cycle_1 + 2*cycle_3 + 1*cycle_2, cycle_1)
					compo_call(composite_a_3, i * 1000 + 6*cycle_1 + 2*cycle_3 + 1*cycle_2, cycle_1)
					compo_call(composite_b_2, i * 1000 + 7*cycle_1 + 2*cycle_3 + 1*cycle_2, cycle_2)
					compo_call(composite_c_2, i * 1000 + 7*cycle_1 + 2*cycle_3 + 2*cycle_2, cycle_3)
					compo_call(composite_a_4, i * 1000 + 7*cycle_1 + 3*cycle_3 + 2*cycle_2, cycle_1)
				end
			end
		end;
		
		-- call first loop
		loop_func();
		
		-- call for subsequent loops
		bm:repeat_callback(
			function() 
				loop_func();
			end, 
			total_length,
			"Merwyrm_loop"
		);

	end
);


-- get_messager():add_listener(
	-- "survival_on",
	-- function()
		-- local loop_func = function()
			-- bm:out("*** Starting wave countdown");
				
			-- for i = 240, 1, -1 do
				-- --
			-- end
			
			-- for i = 59, 1, -1 do
				-- bm:callback(function() bm:set_objective("wh2_dlc11_qb_cst_final_battle_special_wave_count", i) end, (240 - i) * 1000, "Special_countdown_loop");
			-- end;
			
			-- -- remove above objective
			-- bm:callback(function() bm:remove_objective("wh2_dlc11_qb_cst_final_battle_special_wave_count") end, 240000, "Special_countdown_loop");
			
			-- for i = 19, 1, -1 do
				-- bm:callback(function() bm:set_objective("wh2_dlc11_qb_cst_final_battle_special_wave_arrive") end, (240 - i) * 1000, "Special_countdown_loop");
			-- end;
			

			-- -- remove above objective
			-- bm:callback(function() bm:remove_objective("wh2_dlc11_qb_cst_final_battle_special_wave_arrive") end, 240000, "Special_countdown_loop");
			
			-- bm:callback(function() gb.sm:trigger_message("strong_in") end, 240 * 1000, "Special_countdown_loop");
			
	-- end;
		
		-- -- call first loop
		-- loop_func();
		
		-- -- call for subsequent loops
		

	-- end
-- );


-------ORDERS-------


ga_player_01:halt();
ga_ai_01:halt();
--ga_player_ally:halt();
ga_player_01:release_on_message("01_intro_cutscene_end");
ga_ai_01:release_on_message("01_intro_cutscene_end");

--gb:start_terrain_composite_scene_on_message("battle_started", composite_3, 1000);	

--ga_ai_karl:attack_on_message("battle_started");
-- ga_ai_02:attack_on_message("battle_started");
-- ga_ai_02_2:attack_on_message("battle_started");
-- ga_ai_03:attack_on_message("battle_started");
ga_ai_04:attack_on_message("battle_started");

--ga_player_ally:defend_on_message("start", 0, 50, 40); 

ga_ai_02:deploy_at_random_intervals_on_message("survival_on", 3, 3, 90000, 90000);
ga_ai_02:deploy_at_random_intervals_on_message("survival_on", 7, 7, 900000, 900000, nil, true);
ga_ai_02_2:deploy_at_random_intervals_on_message("survival_on", 3, 3, 90000, 90000);
ga_ai_02_2:deploy_at_random_intervals_on_message("survival_on", 7, 7, 900000, 900000, nil, true);
ga_ai_03:deploy_at_random_intervals_on_message("survival_on", 5, 5, 240000, 240000);
ga_player_ally:deploy_at_random_intervals_on_message("survival_on", 2, 2, 60000, 60000);
ga_ai_04:reinforce_on_message("all_waves_gone", 10000);

get_messager():add_listener(
	"survival_on",
	function()
		for i=1,ga_player_ally.sunits:count() do 
			local current_sunit = ga_player_ally.sunits:item(i); 
			bm:watch(
				function()
					return has_deployed(current_sunit);
				end,
				0,
				function()
					out("moving forward "..current_sunit.name);
					current_sunit:goto_location_offset(0, 200, true, nil, true);
					ga_ai_02:release(true);
					ga_ai_02_2:release(true);
					ga_ai_03:release(true);
				end
			)
		end

	end
);

-- for i = 1, 10, 1 do
	-- ga_ai_01:message_on_casualties("casualty"..tostring(i), 0.1*i);
-- end

get_messager():add_listener(
	"01_intro_cutscene_end",
	function()
		bm:callback(function() gb.sm:trigger_message("survival_on"); end, 600000, "123");
	end
);

ga_ai_01:message_on_casualties("survival_on", 0.7);

-- ga_ai_02:message_on_casualties("wave_0_gone", 0.9);
-- ga_ai_02_2:message_on_casualties("wave_1_gone", 0.9);
-- ga_ai_03:message_on_casualties("wave_2_gone", 0.9);

-- remove/cancel timer when boss dies
get_messager():add_listener(
	"all_waves_gone",
	function()
		bm:remove_process("Special_countdown_loop");
		-- bm:remove_objective("wh_dlc05_qb_wef_mini_silver_spire");
		-- bm:remove_objective("wh_dlc05_qb_wef_mini_silver_spire_vulnerable");
	end
);

--gb:message_on_time_offset("survival_on", 60000);

gb:message_on_all_messages_received("all_waves_gone",  "wave_0_gone",  "wave_1_gone", "wave_2_gone");

--gb:message_on_time_offset("start_battle", 10);