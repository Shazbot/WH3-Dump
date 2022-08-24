-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Grom
-- fightyfight
-- Tor Yvresse
-- Attacker

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
intro_cinematic_file = "script\\battle\\quest_battles\\_cutscene\\managers\\grom_fnl_m01.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);
-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

wh2_main_sfx_01 = new_sfx("Play_wh2_dlc15_GOB_Grom_final_battle_pt_01");
wh2_main_sfx_02 = new_sfx("Play_wh2_dlc15_GOB_Grom_final_battle_pt_02");
wh2_main_sfx_03 = new_sfx("Play_wh2_dlc15_GOB_Grom_final_battle_pt_03");
wh2_main_sfx_04 = new_sfx("Play_wh2_dlc15_GOB_Grom_final_battle_pt_04");
wh2_main_sfx_05 = new_sfx("Play_wh2_dlc15_GOB_Grom_final_battle_pt_05");

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_attacker_player = gb:get_army(gb:get_player_alliance_num(), 1, "");
ga_eltharion_enemy = gb:get_army(gb:get_non_player_alliance_num(),"eltharion_enemy");
ga_enemy_city_watch = gb:get_army(gb:get_non_player_alliance_num(),"city_watch_enemy");
ga_ally_battle_boyz = gb:get_army(gb:get_player_alliance_num(),"battle_boyz_ally");
ga_ally_gobbo_waaagh = gb:get_army(gb:get_player_alliance_num(),"gobbo_waaagh");


-------------------------------------------------------------------------------------------------
----------------------------------------- ARMY TELEPORT -----------------------------------------
-------------------------------------------------------------------------------------------------

function battle_start_teleport_units()
	bm:out("\tbattle_start_teleport_units() called");
	
 --teleport unit (1) of ga_artillery to [645, -420] with an orientation of 45 degrees and a width of 25m
	ga_eltharion_enemy.sunits:item(1).uc:teleport_to_location(v(-121, -10), 90, 25);
	--[[ga_ally_gobbo_waaagh.sunits:item(2).uc:teleport_to_location(v(288, -196), 270, 25);		--hero
	ga_ally_gobbo_waaagh.sunits:item(3).uc:teleport_to_location(v(288, -216), 270, 25);		--tower
	ga_ally_gobbo_waaagh.sunits:item(5).uc:teleport_to_location(v(288, -236), 270, 25);		--left gobs
	ga_ally_gobbo_waaagh.sunits:item(6).uc:teleport_to_location(v(288, -266), 270, 25);
	ga_ally_gobbo_waaagh.sunits:item(7).uc:teleport_to_location(v(288, 226), 270, 25);		--right gobs
	ga_ally_gobbo_waaagh.sunits:item(8).uc:teleport_to_location(v(288, 286), 270, 25);
	ga_ally_gobbo_waaagh.sunits:item(9).uc:teleport_to_location(v(300, -199), 270, 25);		--archers
	ga_ally_gobbo_waaagh.sunits:item(11).uc:teleport_to_location(v(288, -304), 270, 25);	-- squigs
	ga_ally_gobbo_waaagh.sunits:item(12).uc:teleport_to_location(v(288, -306), 270, 25);
	ga_ally_gobbo_waaagh.sunits:item(15).uc:teleport_to_location(v(320, -270), 270, 25);	-- wagons
	ga_ally_gobbo_waaagh.sunits:item(17).uc:teleport_to_location(v(320, -240), 270, 25);	--doomdiver ]]
end;

battle_start_teleport_units();	--haha they will just try and move to their original staging area what a bunch of twits
-------------------------------------------------------------------------------------------------
------------------------------------------- CUTSCENE --------------------------------------------
-------------------------------------------------------------------------------------------------

function end_deployment_phase()
	bm:out("\tend_deployment_phase() called");
	bm:out("################## THIS IS SCRIPT LEVEL 1 ################");
	
	-- teleport units into their desired positions
	--battle_start_teleport_units();
	--bm:modify_battle_speed(0);
	ga_attacker_player.sunits:invincible_if_standing(true)
	
	local cam = bm:camera();
	
	-- declare cutscene
	local cutscene_intro = cutscene:new(
		"cutscene_intro", 						-- unique string name for cutscene
		ga_attacker_player.sunits,					-- unitcontroller over player's army
		58500, 									-- duration of cutscene in ms
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
				ga_attacker_player:set_enabled(true)
			end;
		end
	);
	
	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(false, 1) end, 680);
	
	-- cutscene_intro:action(function() cam:move_to(v(-781.747, 84.081, 5.09), v(-770.503, 81.635, 21.587), 0, false, 30) end, 0);	

	cutscene_intro:action(function() bm:cindy_playback("script\\battle\\quest_battles\\_cutscene\\managers\\grom_fnl_m01.CindySceneManager", 0, 2) end, 680);
	cutscene_intro:action(
		function()
			player_units_hidden = false;
			ga_attacker_player:set_enabled(true) 
		end, 
		680
	);	
	
	-- Voiceover and Subtitles --\
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_01) end, 2000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc15_GOB_Grom_final_battle_pt_01", "subtitle_with_frame", 2, true) end, 2000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 13500);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_02) end, 14000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc15_GOB_Grom_final_battle_pt_02", "subtitle_with_frame", 2, true) end, 14000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 22500);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_03) end, 23000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc15_GOB_Grom_final_battle_pt_03", "subtitle_with_frame", 2, true) end, 23000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 33500);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_04) end, 34000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc15_GOB_Grom_final_battle_pt_04", "subtitle_with_frame", 2, true) end, 34000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 46500);

	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_05) end, 47000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc15_GOB_Grom_final_battle_pt_05", "subtitle_with_frame", 2, true) end, 47000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 58500);
	
	cutscene_intro:start();
	
end;

function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end")
	ga_attacker_player.sunits:set_invincible(false)
	ga_attacker_player.sunits:morale_behavior_default_if_standing(true)
end;


-------------------------------------------------------------------------------------------------
------------------------------------------ ORDERS -------------------------------------------
-------------------------------------------------------------------------------------------------
--Stopping armies from firing until the cutscene is done
ga_attacker_player:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_attacker_player:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);
ga_enemy_city_watch:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_enemy_city_watch:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);
ga_eltharion_enemy:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_eltharion_enemy:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);
ga_ally_battle_boyz:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_ally_battle_boyz:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);
ga_ally_gobbo_waaagh:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_ally_gobbo_waaagh:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);
--[[
-- stop them hurting each other until the bell rings
ga_attacker_player:set_invincible_on_message("battle_started", true);
ga_enemy_city_watch:set_invincible_on_message("battle_started", true);
ga_eltharion_enemy:set_invincible_on_message("battle_started", true);
gb:message_on_time_offset("hurt_me", 1500,"01_intro_cutscene_end");
ga_attacker_player:set_invincible_on_message("hurt_me", false);			-- for some reason this was causing units to be locked out of control, so alternative method has been added within the cutscene functions
ga_enemy_city_watch:set_invincible_on_message("hurt_me", false);
ga_eltharion_enemy:set_invincible_on_message("hurt_me", false);
]]
-- give em a little extra spice
ga_eltharion_enemy:add_winds_of_magic_on_message("01_intro_cutscene_end", 20)
ga_enemy_city_watch:add_winds_of_magic_on_message("01_intro_cutscene_end", 20)

gb:message_on_time_offset("army_ability", 6000,"01_intro_cutscene_end");
gb:message_on_time_offset("army_ability_off", 14000,"01_intro_cutscene_end");

gb:message_on_time_offset("gobbo_chaaarge", 20000,"battle_started");
gb:message_on_time_offset("get_em_boyz", 20000,"battle_started");
gb:message_on_time_offset("gobbo_chaaarge", 100,"01_intro_cutscene_end");
gb:message_on_time_offset("get_em_boyz", 100,"01_intro_cutscene_end");
gb:message_on_time_offset("gobbo_release", 30000,"gobbo_chaaarge");
gb:message_on_time_offset("release_da_boyz", 30000,"get_em_boyz");
--gb:message_on_time_offset("send_in_da_battle_boyz", 30000,"01_intro_cutscene_end");
gb:message_on_time_offset("release_all", 500,"01_intro_cutscene_end");


gb:message_on_time_offset("block_gobbo_chaaarge", 3000,"gobbo_chaaarge");
gb:block_message_on_message("block_gobbo_chaaarge", "gobbo_chaaarge", true)

gb:message_on_time_offset("block_get_em_boyz", 3000,"get_em_boyz");
gb:block_message_on_message("block_get_em_boyz", "get_em_boyz", true)


--ga_eltharion_enemy:message_on_proximity_to_enemy("send_in_da_battle_boyz", 20);
--ga_ally_battle_boyz:reinforce_on_message("send_in_da_battle_boyz");
--ga_ally_battle_boyz:message_on_deployed("get_em_boyz");

--ga_eltharion_enemy:attack_on_message("01_intro_cutscene_end");
ga_ally_battle_boyz:attack_on_message("get_em_boyz");
ga_ally_gobbo_waaagh:attack_on_message("gobbo_chaaarge");


-- Releases
ga_eltharion_enemy:release_on_message("release_all");
--ga_ally_battle_boyz:release_on_message("release_all");
ga_enemy_city_watch:release_on_message("release_all");
ga_ally_battle_boyz:release_on_message("release_da_boyz");
ga_ally_gobbo_waaagh:release_on_message("gobbo_release");

ga_attacker_player:message_on_casualties("send_in_da_battle_boyz", 0.25);	-- Just in case Groms army gets shot to heck before they do anything
ga_eltharion_enemy:message_on_commander_death("eltharion_dead", 1);


-------------------------------------------------------------------------------------------------
------------------------------------------- TRAPS -----------------------------------------------
-------------------------------------------------------------------------------------------------
-- Water trap
--gb:add_ping_icon_on_message("01_intro_cutscene_end", v(-216, 30.1, 0), 16, 2000);
ga_attacker_player:message_on_proximity_to_position("water_trap_activate", v(-216, 30.1, 0), 20);
ga_ally_battle_boyz:message_on_proximity_to_position("water_trap_activate", v(-216, 30.1, 0), 20);
ga_ally_gobbo_waaagh:message_on_proximity_to_position("water_trap_activate", v(-216, 30.1, 0), 20);
--gb:remove_ping_icon_on_message("water_trap_activate", v(-216, 30.1, 0), 16, 2000);
ga_enemy_city_watch:use_army_special_ability_on_message("water_trap_activate", "wh2_dlc15_army_abilities_flood_trap", v(-216, 30.1, 0), d_to_r(90));
gb:message_on_time_offset("block_water_trap_activate", 3000,"water_trap_activate");
gb:block_message_on_message("block_water_trap_activate", "water_trap_activate", true)

-- Lightning traps
--gb:add_ping_icon_on_message("01_intro_cutscene_end", v(-371, 55.5, 128), 16, 2000);	-- north
ga_attacker_player:message_on_proximity_to_position("n_lightning_trap_activate", v(-371, 55.5, 128), 25);
ga_ally_battle_boyz:message_on_proximity_to_position("n_lightning_trap_activate", v(-371, 55.5, 128), 25);
ga_ally_gobbo_waaagh:message_on_proximity_to_position("n_lightning_trap_activate", v(-371, 55.5, 128), 25);
--gb:remove_ping_icon_on_message("n_lightning_trap_activate", v(-371, 55.5, 128), 16, 2000);
ga_enemy_city_watch:use_army_special_ability_on_message("n_lightning_trap_activate", "wh2_dlc15_army_abilities_lightning_trap_1", v(-371, 55.5, 128));
gb:message_on_time_offset("block_n_lightning_trap_activate", 3000,"n_lightning_trap_activate");
gb:block_message_on_message("block_n_lightning_trap_activate", "n_lightning_trap_activate", true)

--gb:add_ping_icon_on_message("01_intro_cutscene_end", v(-371, 55.5, -128), 16, 2000);	-- south
ga_attacker_player:message_on_proximity_to_position("s_lightning_trap_activate", v(-371, 55.5, -128), 25);
ga_ally_battle_boyz:message_on_proximity_to_position("s_lightning_trap_activate", v(-371, 55.5, -128), 25);
ga_ally_gobbo_waaagh:message_on_proximity_to_position("s_lightning_trap_activate", v(-371, 55.5, -128), 25);
--gb:remove_ping_icon_on_message("s_lightning_trap_activate", v(-371, 55.5, -128), 16, 2000);
ga_enemy_city_watch:use_army_special_ability_on_message("s_lightning_trap_activate", "wh2_dlc15_army_abilities_lightning_trap_2", v(-371, 55.5, -128), d_to_r(180));
gb:message_on_time_offset("block_s_lightning_trap_activate", 3000,"s_lightning_trap_activate");
gb:block_message_on_message("block_s_lightning_trap_activate", "s_lightning_trap_activate", true)

-- Wind traps (1-3 going from north to south)
-- 1 top
ga_attacker_player:message_on_proximity_to_position("1_wind_trap_activate", v(106, 257), 65);
ga_attacker_player:message_on_proximity_to_position("1_wind_trap_activate", v(106, 164), 65);
ga_ally_battle_boyz:message_on_proximity_to_position("1_wind_trap_activate", v(106, 257), 65);
ga_ally_battle_boyz:message_on_proximity_to_position("1_wind_trap_activate", v(106, 164), 65);
ga_ally_gobbo_waaagh:message_on_proximity_to_position("1_wind_trap_activate", v(106, 257), 65);
ga_ally_gobbo_waaagh:message_on_proximity_to_position("1_wind_trap_activate", v(106, 164), 65);
ga_enemy_city_watch:use_army_special_ability_on_message("1_wind_trap_activate", "wh2_dlc15_army_abilities_wind_trap_1a", v(151, 295), d_to_r(180));
ga_enemy_city_watch:use_army_special_ability_on_message("1_wind_trap_activate", "wh2_dlc15_army_abilities_wind_trap_1b", v(151, 127));
gb:message_on_time_offset("block_1_wind_trap_activate", 3000,"1_wind_trap_activate");
gb:block_message_on_message("block_1_wind_trap_activate", "1_wind_trap_activate", true);

-- 2 mid
ga_attacker_player:message_on_proximity_to_position("2_wind_trap_activate", v(106, 43), 65);
ga_attacker_player:message_on_proximity_to_position("2_wind_trap_activate", v(106, -51), 65);
ga_ally_battle_boyz:message_on_proximity_to_position("2_wind_trap_activate", v(106, 43), 65);
ga_ally_battle_boyz:message_on_proximity_to_position("2_wind_trap_activate", v(106, -51), 65);
ga_ally_gobbo_waaagh:message_on_proximity_to_position("2_wind_trap_activate", v(106, 43), 65);
ga_ally_gobbo_waaagh:message_on_proximity_to_position("2_wind_trap_activate", v(106, -51), 65);
ga_enemy_city_watch:use_army_special_ability_on_message("2_wind_trap_activate", "wh2_dlc15_army_abilities_wind_trap_2a", v(151, 87), d_to_r(180));
ga_enemy_city_watch:use_army_special_ability_on_message("2_wind_trap_activate", "wh2_dlc15_army_abilities_wind_trap_2b", v(151, -94));
gb:message_on_time_offset("block_2_wind_trap_activate", 3000, "2_wind_trap_activate");
gb:block_message_on_message("block_2_wind_trap_activate", "2_wind_trap_activate", true);

-- 3 bot
ga_attacker_player:message_on_proximity_to_position("3_wind_trap_activate", v(106, -173), 65);
ga_attacker_player:message_on_proximity_to_position("3_wind_trap_activate", v(106, -258), 65);
ga_ally_battle_boyz:message_on_proximity_to_position("3_wind_trap_activate", v(106, -173), 65);
ga_ally_battle_boyz:message_on_proximity_to_position("3_wind_trap_activate", v(106, -258), 65);
ga_ally_gobbo_waaagh:message_on_proximity_to_position("3_wind_trap_activate", v(106, -173), 65);
ga_ally_gobbo_waaagh:message_on_proximity_to_position("3_wind_trap_activate", v(106, -258), 65);
ga_enemy_city_watch:use_army_special_ability_on_message("3_wind_trap_activate", "wh2_dlc15_army_abilities_wind_trap_3a", v(151, -129), d_to_r(180));
ga_enemy_city_watch:use_army_special_ability_on_message("3_wind_trap_activate", "wh2_dlc15_army_abilities_wind_trap_3b", v(151, -303));
gb:message_on_time_offset("block_3_wind_trap_activate", 3000, "3_wind_trap_activate");
gb:block_message_on_message("block_3_wind_trap_activate", "3_wind_trap_activate", true);


--- Eltharion Army Ability Triggers

-- Summon the Sentinals
ga_attacker_player:message_on_proximity_to_position("summon_trap_activate", v(-325, 51.8, 0), 20);
ga_ally_battle_boyz:message_on_proximity_to_position("summon_trap_activate", v(-325, 51.8, 0), 20);
ga_ally_gobbo_waaagh:message_on_proximity_to_position("summon_trap_activate", v(-325, 51.8, 0), 20);
ga_eltharion_enemy:use_army_special_ability_on_message("summon_trap_activate", "wh2_dlc15_army_abilities_summon_the_sentinels_upgraded", v(-325, 51.8, 0), d_to_r(90));

ga_eltharion_enemy:use_army_special_ability_on_message("s_lightning_trap_activate", "wh2_dlc15_army_abilities_summon_the_sentinels_upgraded", v(-371, 45.5, -192));

ga_eltharion_enemy:use_army_special_ability_on_message("n_lightning_trap_activate", "wh2_dlc15_army_abilities_summon_the_sentinels_upgraded", v(-371, 45.5, 192), d_to_r(180));

-- Oath of Replenishment
gb:message_on_time_offset("replenish_pls", 300000,"01_intro_cutscene_end");
ga_eltharion_enemy:use_army_special_ability_on_message("replenish_pls", "wh2_dlc15_army_abilities_oath_of_replenishment_upgraded");

-- Invocation of Ending
--ga_eltharion_enemy:use_army_special_ability_on_message("replenish_pls", "wh2_dlc15_army_abilities_invocation_of_ending", v(-325, 51.8, 0));

-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------

gb:set_objective_on_message("01_intro_cutscene_end", "wh2_dlc15_qb_grn_grom_final_battle_objective_01");
gb:set_objective_on_message("01_intro_cutscene_end", "wh2_dlc15_qb_grn_grom_final_battle_objective_02");

gb:complete_objective_on_message("eltharion_dead", "wh2_dlc15_qb_grn_grom_final_battle_objective_02", 5);

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:message_on_any_message_received("tell_me_about_traps", "1_wind_trap_activate", "2_wind_trap_activate", "3_wind_trap_activate");
gb:message_on_time_offset("stop_telling_me_about_traps", 500, "tell_me_about_traps");
gb:block_message_on_message("stop_telling_me_about_traps", "tell_me_about_traps", true);

gb:queue_help_on_message("tell_me_about_traps", "wh2_dlc15_qb_grn_grom_final_battle_hint_traps", 6000, nil, 15000);
gb:queue_help_on_message("army_ability", "wh2_dlc15_qb_grn_grom_final_battle_hint_doom_divers", 6000, nil, 1000);

gb:add_listener("army_ability", function() highlight_army_ability(true) end)
gb:add_listener("army_ability_off", function() highlight_army_ability(false) end)
-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------
local army_abilities = {
	"wh2_dlc15_army_abilities_doom_diver_strike",
};


function highlight_army_ability(value)
	local army_ability_parent = get_army_ability_parent();
	
	for i = 1, #army_abilities do
		local uic_ability = find_uicomponent(army_ability_parent, "button_ability_" .. army_abilities[i]);
		if uic_ability then
			uic_ability:Highlight(value, false, 100);
		else
			script_error("WARNING: highlight_army_ability() failed to find army abilities uicomponent for ability [" .. tostring(army_abilities[i]) .. "], the highlighting action won't happen");
		end;
	end;
end;

function get_army_ability_parent()
	return find_uicomponent(core:get_ui_root(), "army_ability_parent");
end;

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------