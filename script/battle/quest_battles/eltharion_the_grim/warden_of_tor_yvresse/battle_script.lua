-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Eltharion
-- Warden of Tor Yvresse
-- INSERT ENVIRONMENT NAME
-- Defender

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------


load_script_libraries();
bm = battle_manager:new(empire_battle:new());

bm:camera():fade(false, 0);
bm:enable_cinematic_ui(false, true, false)		-- ensures UI is avaiable during deployment

gb = generated_battle:new(
	false,                                      		    -- screen starts black
	false,                                      		-- prevent deployment for player
	false,                                      		    -- prevent deployment for ai
	function() end_deployment_phase() end,          	-- intro cutscene function
	false                                      			-- debug mode
);

--preload stuttering fix
intro_cinematic_file = "script\\battle\\quest_battles\\_cutscene\\managers\\elth_fnl_m01.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);
-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

wh2_main_sfx_01 = new_sfx("Play_wh2_dlc15_hef_eltharion_final_battle_pt_01");
wh2_main_sfx_02 = new_sfx("Play_wh2_dlc15_hef_eltharion_final_battle_pt_02");
wh2_main_sfx_03 = new_sfx("Play_wh2_dlc15_hef_eltharion_final_battle_pt_03");
wh2_main_sfx_04 = new_sfx("Play_wh2_dlc15_hef_eltharion_final_battle_pt_04");
wh2_main_sfx_05 = new_sfx("Play_wh2_dlc15_hef_eltharion_final_battle_pt_05");

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_defender_player = gb:get_army(gb:get_player_alliance_num(), 1, "");
ga_ally_city_watch = gb:get_army(gb:get_player_alliance_num(),"city_watch");
ga_enemy_grom = gb:get_army(gb:get_non_player_alliance_num(),"grom_enemy");
ga_enemy_spider_squad = gb:get_army(gb:get_non_player_alliance_num(),"spider_squad");
ga_enemy_eavy_smashas = gb:get_army(gb:get_non_player_alliance_num(),"eavy_smashas");
ga_enemy_battle_boyz = gb:get_army(gb:get_non_player_alliance_num(),"battle_boyz");


-------------------------------------------------------------------------------------------------
----------------------------------------- ARMY TELEPORT -----------------------------------------
-------------------------------------------------------------------------------------------------

function battle_start_teleport_units()
	bm:out("\tbattle_start_teleport_units() called");
	
--teleport unit (1) of ga_artillery to [645, -420] with an orientation of 45 degrees and a width of 25m
--ga_defender_player.sunits:item(1).uc:teleport_to_location(v(-121, 0), 90, 25);
ga_enemy_grom.sunits:item(1).uc:teleport_to_location(v(409, 0), 270, 25);
end;

battle_start_teleport_units();
-------------------------------------------------------------------------------------------------
------------------------------------------- CUTSCENE --------------------------------------------
-------------------------------------------------------------------------------------------------

function end_deployment_phase()
	bm:out("\tend_deployment_phase() called");
	bm:out("################## THIS IS SCRIPT LEVEL 1 ################");
	
	-- teleport units into their desired positions
	--battle_start_teleport_units();
	--bm:modify_battle_speed(0);
	
	local cam = bm:camera();
	
	-- declare cutscene
	local cutscene_intro = cutscene:new(
		"cutscene_intro", 						-- unique string name for cutscene
		ga_defender_player.sunits,					-- unitcontroller over player's army
		72000, 									-- duration of cutscene in ms
		function() intro_cutscene_end() end		-- what to call when cutscene is finished
	);
	
	local player_units_hidden = false;
	
	-- set up subtitles
	local subtitles = cutscene_intro:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();
		
	cutscene_intro:set_post_cutscene_fade_time(3.0, 3000);
	
	-- skip callback
	cutscene_intro:set_skippable(
		true, 
		function()		
			local cam = bm:camera();
			bm:stop_cindy_playback(true);		
			if player_units_hidden then
				ga_defender_player:set_enabled(true)
			end;
		end
	);
	
	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(false, 1) end, 680);
	
	-- cutscene_intro:action(function() cam:move_to(v(-781.747, 84.081, 5.09), v(-770.503, 81.635, 21.587), 0, false, 30) end, 0);	

	cutscene_intro:action(function() bm:cindy_playback("script\\battle\\quest_battles\\_cutscene\\managers\\elth_fnl_m01.CindySceneManager", 0, 2) end, 680);
	cutscene_intro:action(
		function()
			player_units_hidden = false;
			ga_defender_player:set_enabled(true) 
		end, 
		680
	);	
	
	-- Voiceover and Subtitles --\
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_01) end, 2000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc15_hef_Eltharion_final_battle_pt_01", "subtitle_with_frame", 0.1, true) end, 2000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 14000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_02) end, 15000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc15_hef_Eltharion_final_battle_pt_02", "subtitle_with_frame", 0.1, true) end, 15000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 24000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_03) end, 25000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc15_hef_Eltharion_final_battle_pt_03", "subtitle_with_frame", 0.1, true) end, 25000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 35000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_04) end, 36000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc15_hef_Eltharion_final_battle_pt_04", "subtitle_with_frame", 0.1, true) end, 36000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 53000);

	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_05) end, 54000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc15_hef_Eltharion_final_battle_pt_05", "subtitle_with_frame", 0.1, true) end, 54000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 72000);
	cutscene_intro:start();
	
end;

function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end")
end;


-------------------------------------------------------------------------------------------------
------------------------------------------ ORDERS -------------------------------------------
-------------------------------------------------------------------------------------------------
--Stopping armies from firing until the cutscene is done
ga_defender_player:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_defender_player:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);
ga_ally_city_watch:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_ally_city_watch:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);
ga_enemy_grom:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_enemy_grom:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);
ga_enemy_spider_squad:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_enemy_spider_squad:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);
ga_enemy_eavy_smashas:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_enemy_eavy_smashas:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);
--[[
ga_enemy_grom:change_behaviour_active_on_message("battle_started", "defend", true, true);
ga_enemy_grom:change_behaviour_active_on_message("01_intro_cutscene_end", "defend", false, false);
ga_enemy_spider_squad:change_behaviour_active_on_message("battle_started", "defend", true, true);
ga_enemy_spider_squad:change_behaviour_active_on_message("01_intro_cutscene_end", "defend", false, false);
ga_enemy_eavy_smashas:change_behaviour_active_on_message("battle_started", "defend", true, true);
ga_enemy_eavy_smashas:change_behaviour_active_on_message("01_intro_cutscene_end", "defend", false, false);]]

-- give em a little extra spice
ga_enemy_grom:add_winds_of_magic_on_message("01_intro_cutscene_end", 20)
ga_enemy_spider_squad:add_winds_of_magic_on_message("01_intro_cutscene_end", 20)
ga_defender_player:add_winds_of_magic_on_message("01_intro_cutscene_end", 5)

-- break da walls
gb:message_on_time_offset("doom_diver_strike_1", 75000,"battle_started");
--ga_enemy_grom:use_army_special_ability_on_message("doom_diver_strike", "wh2_dlc15_army_abilities_doom_diver_strike", v(-70, 0));	--gate coords
ga_enemy_grom:use_army_special_ability_on_message("doom_diver_strike_1", "wh2_dlc15_army_abilities_doom_diver_strike_enhanced", v(-20, -170));
gb:message_on_time_offset("doom_diver_strike_2", 75000,"doom_diver_strike_1");
ga_enemy_grom:use_army_special_ability_on_message("doom_diver_strike_2", "wh2_dlc15_army_abilities_doom_diver_strike_enhanced", v(-20, 330));
gb:message_on_time_offset("doom_diver_strike_3", 75000,"doom_diver_strike_2");
ga_enemy_grom:use_army_special_ability_on_message("doom_diver_strike_3", "wh2_dlc15_army_abilities_doom_diver_strike_enhanced", v(-70, 80));

--gb:message_on_time_offset("eavy_smashas_reinforce", 20000,"01_intro_cutscene_end");
gb:message_on_time_offset("send_in_da_battle_boyz", 350000,"01_intro_cutscene_end");
gb:message_on_time_offset("release_all", 360000,"01_intro_cutscene_end");
gb:message_on_time_offset("release_da_boyz", 120000,"get_em_boyz");		-- make sure those boyz get a release message if they reinforce after release all

gb:message_on_time_offset("smash_em", 10000,"doom_diver_strike_2");
--gb:message_on_time_offset("release_da_spiders", 250000,"smash_em");	--not really needed actually
gb:message_on_time_offset("spider_move", 60000,"smash_em");	


--ga_enemy_eavy_smashas:reinforce_on_message("eavy_smashas_reinforce");
--ga_enemy_eavy_smashas:message_on_deployed("smash_em");
ga_enemy_grom:message_on_proximity_to_enemy("send_in_da_battle_boyz", 5);
ga_enemy_battle_boyz:reinforce_on_message("send_in_da_battle_boyz");
ga_enemy_battle_boyz:message_on_deployed("get_em_boyz");

--ga_enemy_grom:attack_on_message("01_intro_cutscene_end");
ga_enemy_spider_squad:attack_on_message("smash_em");
ga_enemy_spider_squad:move_to_position_on_message("spider_move", v(-493, 302));
--ga_enemy_spider_squad:goto_location_offset_on_message("smash_em", 100, -700, true);
--ga_enemy_eavy_smashas:attack_on_message("smash_em");
ga_enemy_battle_boyz:attack_on_message("get_em_boyz");


-- Releases
ga_enemy_grom:release_on_message("release_all");
ga_enemy_grom:release_on_message("release_all");
ga_enemy_spider_squad:release_on_message("release_all");
ga_enemy_eavy_smashas:release_on_message("release_all");
ga_enemy_battle_boyz:release_on_message("release_all");
ga_enemy_battle_boyz:release_on_message("release_da_boyz");
ga_enemy_spider_squad:release_on_message("release_da_spiders");


ga_enemy_grom:message_on_casualties("send_in_da_battle_boyz", 0.25);	-- Just in case Groms army gets shot to heck before they do anything
ga_enemy_grom:message_on_commander_death("grom_dead", 1);


-------------------------------------------------------------------------------------------------
------------------------------------------- TRAPS -----------------------------------------------
-------------------------------------------------------------------------------------------------
-- Water trap
gb:add_ping_icon_on_message("01_intro_cutscene_end", v(-216, 30.1, 0), 16, 2000);
ga_enemy_grom:message_on_proximity_to_position("water_trap_activate", v(-216, 30.1, 0), 20);
ga_enemy_spider_squad:message_on_proximity_to_position("water_trap_activate", v(-216, 30.1, 0), 20);
ga_enemy_battle_boyz:message_on_proximity_to_position("water_trap_activate", v(-216, 30.1, 0), 20);
ga_enemy_eavy_smashas:message_on_proximity_to_position("water_trap_activate", v(-216, 30.1, 0), 20);
gb:remove_ping_icon_on_message("water_trap_activate", v(-216, 30.1, 0), 16, 2000);
ga_ally_city_watch:use_army_special_ability_on_message("water_trap_activate", "wh2_dlc15_army_abilities_flood_trap", v(-240, 36, 0), d_to_r(90));
gb:message_on_time_offset("block_water_trap_activate", 3000,"water_trap_activate");
gb:block_message_on_message("block_water_trap_activate", "water_trap_activate", true)

-- Lightning traps
gb:add_ping_icon_on_message("01_intro_cutscene_end", v(-371, 55.5, 128), 16, 2000);	-- north
ga_enemy_grom:message_on_proximity_to_position("n_lightning_trap_activate", v(-371, 55.5, 128), 25);
ga_enemy_spider_squad:message_on_proximity_to_position("n_lightning_trap_activate", v(-371, 55.5, 128), 25);
ga_enemy_battle_boyz:message_on_proximity_to_position("n_lightning_trap_activate", v(-371, 55.5, 128), 25);
ga_enemy_eavy_smashas:message_on_proximity_to_position("n_lightning_trap_activate", v(-371, 55.5, 128), 25);
gb:remove_ping_icon_on_message("n_lightning_trap_activate", v(-371, 55.5, 128), 16, 2000);
ga_ally_city_watch:use_army_special_ability_on_message("n_lightning_trap_activate", "wh2_dlc15_army_abilities_lightning_trap_1", v(-371, 55.5, 128));
gb:message_on_time_offset("block_n_lightning_trap_activate", 3000,"n_lightning_trap_activate");
gb:block_message_on_message("block_n_lightning_trap_activate", "n_lightning_trap_activate", true)

gb:add_ping_icon_on_message("01_intro_cutscene_end", v(-371, 55.5, -128), 16, 2000);	-- south
ga_enemy_grom:message_on_proximity_to_position("s_lightning_trap_activate", v(-371, 55.5, -128), 25);
ga_enemy_spider_squad:message_on_proximity_to_position("s_lightning_trap_activate", v(-371, 55.5, -128), 25);
ga_enemy_battle_boyz:message_on_proximity_to_position("s_lightning_trap_activate", v(-371, 55.5, -128), 25);
ga_enemy_eavy_smashas:message_on_proximity_to_position("s_lightning_trap_activate", v(-371, 55.5, -128), 25);
gb:remove_ping_icon_on_message("s_lightning_trap_activate", v(-371, 55.5, -128), 16, 2000);
ga_ally_city_watch:use_army_special_ability_on_message("s_lightning_trap_activate", "wh2_dlc15_army_abilities_lightning_trap_2", v(-371, 55.5, -128), d_to_r(180));
gb:message_on_time_offset("block_s_lightning_trap_activate", 3000,"s_lightning_trap_activate");
gb:block_message_on_message("block_s_lightning_trap_activate", "s_lightning_trap_activate", true)

-- Wind traps (1-3 going from north to south)
-- 1 top
ga_enemy_grom:message_on_proximity_to_position("1_wind_trap_activate", v(106, 257), 65);
ga_enemy_grom:message_on_proximity_to_position("1_wind_trap_activate", v(106, 164), 65);
ga_enemy_spider_squad:message_on_proximity_to_position("1_wind_trap_activate", v(106, 257), 65);
ga_enemy_spider_squad:message_on_proximity_to_position("1_wind_trap_activate", v(106, 164), 65);
ga_enemy_battle_boyz:message_on_proximity_to_position("1_wind_trap_activate", v(106, 257), 65);
ga_enemy_battle_boyz:message_on_proximity_to_position("1_wind_trap_activate", v(106, 164), 65);
ga_enemy_eavy_smashas:message_on_proximity_to_position("1_wind_trap_activate", v(106, 257), 65);
ga_enemy_eavy_smashas:message_on_proximity_to_position("1_wind_trap_activate", v(106, 164), 65);
ga_ally_city_watch:use_army_special_ability_on_message("1_wind_trap_activate", "wh2_dlc15_army_abilities_wind_trap_1a", v(151, 295), d_to_r(180));
ga_ally_city_watch:use_army_special_ability_on_message("1_wind_trap_activate", "wh2_dlc15_army_abilities_wind_trap_1b", v(151, 127));
gb:message_on_time_offset("block_1_wind_trap_activate", 3000,"1_wind_trap_activate");
gb:block_message_on_message("block_1_wind_trap_activate", "1_wind_trap_activate", true);

-- 2 mid
ga_enemy_grom:message_on_proximity_to_position("2_wind_trap_activate", v(106, 43), 65);
ga_enemy_grom:message_on_proximity_to_position("2_wind_trap_activate", v(106, -51), 65);
ga_enemy_spider_squad:message_on_proximity_to_position("2_wind_trap_activate", v(106, 43), 65);
ga_enemy_spider_squad:message_on_proximity_to_position("2_wind_trap_activate", v(106, -51), 65);
ga_enemy_battle_boyz:message_on_proximity_to_position("2_wind_trap_activate", v(106, 43), 65);
ga_enemy_battle_boyz:message_on_proximity_to_position("2_wind_trap_activate", v(106, -51), 65);
ga_enemy_eavy_smashas:message_on_proximity_to_position("2_wind_trap_activate", v(106, 43), 65);
ga_enemy_eavy_smashas:message_on_proximity_to_position("2_wind_trap_activate", v(106, -51), 65);
ga_ally_city_watch:use_army_special_ability_on_message("2_wind_trap_activate", "wh2_dlc15_army_abilities_wind_trap_2a", v(151, 87), d_to_r(180));
ga_ally_city_watch:use_army_special_ability_on_message("2_wind_trap_activate", "wh2_dlc15_army_abilities_wind_trap_2b", v(151, -94));
gb:message_on_time_offset("block_2_wind_trap_activate", 3000, "2_wind_trap_activate");
gb:block_message_on_message("block_2_wind_trap_activate", "2_wind_trap_activate", true);

-- 3 bot
ga_enemy_grom:message_on_proximity_to_position("3_wind_trap_activate", v(106, -173), 65);
ga_enemy_grom:message_on_proximity_to_position("3_wind_trap_activate", v(106, -258), 65);
ga_enemy_spider_squad:message_on_proximity_to_position("3_wind_trap_activate", v(106, -173), 65);
ga_enemy_spider_squad:message_on_proximity_to_position("3_wind_trap_activate", v(106, -258), 65);
ga_enemy_battle_boyz:message_on_proximity_to_position("3_wind_trap_activate", v(106, -173), 65);
ga_enemy_battle_boyz:message_on_proximity_to_position("3_wind_trap_activate", v(106, -258), 65);
ga_enemy_eavy_smashas:message_on_proximity_to_position("3_wind_trap_activate", v(106, -173), 65);
ga_enemy_eavy_smashas:message_on_proximity_to_position("3_wind_trap_activate", v(106, -258), 65);
ga_ally_city_watch:use_army_special_ability_on_message("3_wind_trap_activate", "wh2_dlc15_army_abilities_wind_trap_3a", v(151, -129), d_to_r(180));
ga_ally_city_watch:use_army_special_ability_on_message("3_wind_trap_activate", "wh2_dlc15_army_abilities_wind_trap_3b", v(151, -303));
gb:message_on_time_offset("block_3_wind_trap_activate", 3000, "3_wind_trap_activate");
gb:block_message_on_message("block_3_wind_trap_activate", "3_wind_trap_activate", true);

-- tell me about traps when it gets windy
gb:message_on_any_message_received("tell_me_about_traps", "1_wind_trap_activate", "2_wind_trap_activate", "3_wind_trap_activate");
gb:message_on_time_offset("stop_telling_me_about_traps", 500, "tell_me_about_traps");
gb:block_message_on_message("stop_telling_me_about_traps", "tell_me_about_traps", true);

gb:message_on_any_message_received("tell_me_a_city_trap_activated", "water_trap_activate", "n_lightning_trap_activate", "s_lightning_trap_activate");
--
--ga_enemy_grom:message_on_proximity_to_enemy("water_trap_activate", 200);	--just for testing

--ga_enemy_grom:message_on_proximity_to_position("1_wind_trap_activate", v(130, 8.6, 315), 50);	--singular for ref
--ga_enemy_grom:message_on_proximity_to_position("2_wind_trap_activate", v(130, 6.5, 107), 50);	--singular for ref
--ga_enemy_grom:message_on_proximity_to_position("3_wind_trap_activate", v(130, 11, -115), 50);	--singular for ref
--ga_enemy_grom:message_on_proximity_to_position("4_wind_trap_activate", v(130, 17.3, -319), 50);	--singular for ref
-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------

gb:set_objective_on_message("01_intro_cutscene_end", "wh2_dlc15_qb_hef_eltharion_final_battle_objective_01");
gb:set_objective_on_message("01_intro_cutscene_end", "wh2_dlc15_qb_hef_eltharion_final_battle_objective_02");

gb:complete_objective_on_message("grom_dead", "wh2_dlc15_qb_hef_eltharion_final_battle_objective_02", 5);

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:queue_help_on_message("send_in_da_battle_boyz", "wh2_dlc15_qb_hef_eltharion_final_battle_hint_battle_boyz", 6000, nil, 5000);
gb:queue_help_on_message("tell_me_about_traps", "wh2_dlc15_qb_hef_eltharion_final_battle_hint_traps", 6000, nil, 10000);
gb:queue_help_on_message("tell_me_a_city_trap_activated", "wh2_dlc15_qb_hef_eltharion_final_battle_hint_traps_inner_city", 6000, nil, 1000);

--bm:add_infotext("wh2_dlc15.camp.advice.dragon_taming.info_001");

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------
-- Add tooltips to Trap ping marker icons


gb.sm:add_listener(
	"add_ping_tooltips",
	function()
		local uic_ping_icon_parent = find_uicomponent(core:get_ui_root(), "ping_parent");
		if not uic_ping_icon_parent then
			script_error("WARNING: ping icon parent not found - no ping icon tooltips will be set");
			return;
		end;

		local text_key = "trap_icon_tooltip";

		for i = 0, uic_ping_icon_parent:ChildCount() - 1 do
			local uic_ping_icon_button = find_uicomponent(UIComponent(uic_ping_icon_parent:Find(i)), "icon");
			uic_ping_icon_button:SetTooltipTextWithRLSKey(text_key,	true);
		end;
	end
);

gb:message_on_time_offset("add_ping_tooltips", 3000,"01_intro_cutscene_end");
-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------