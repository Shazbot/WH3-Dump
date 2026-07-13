-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Bhashiva
-- Heaven's Gate

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------

load_script_libraries();
bm = battle_manager:new(empire_battle:new());

gb = generated_battle:new(
	true,                                      		    -- screen starts black
	false,                                      			-- prevent deployment for player
	true,                                      		    -- prevent deployment for ai
	function() end_deployment_phase() end,          	-- intro cutscene function
	false                                      			-- debug mode
);

gb:set_cutscene_during_deployment(true);

intro_cinematic_file = "script/battle/quest_battles/_cutscene/managers/wh3_bhashiva_qb_intro.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);
mid_cinematic_file = "script/battle/quest_battles/_cutscene/managers/wh3_bhashiva_qb_mid.CindySceneManager";
bm:cindy_preload(mid_cinematic_file);


-------------------------------------------------------------------------------------------------
------------------------------------- INTRO CUTSCENE --------------------------------------------
-------------------------------------------------------------------------------------------------

local sfx_cutscene_sweetener_intro_play = new_sfx("Play_Movie_WH3_CP1_QB_Bhashiva_Ogres_Folly_Intro", true, false)
local sfx_cutscene_sweetener_mid_play = new_sfx("Play_Movie_WH3_CP1_QB_Bhashiva_Ogres_Folly_Mid", true, false)
local sfx_cutscene_sweetener_intro_stop = new_sfx("Stop_Movie_WH3_CP1_QB_Bhashiva_Ogres_Folly_Intro", false, false)
local sfx_cutscene_sweetener_mid_stop = new_sfx("Stop_Movie_WH3_CP1_QB_Bhashiva_Ogres_Folly_Mid", false, false)

function end_deployment_phase()
	bm:out("\tend_deployment_phase() called");
	
	local cam = bm:camera();

	-- declare cutscene
	local cutscene_intro = cutscene:new_from_cindyscene(
		"cutscene_intro", 																-- unique string name for cutscene
		ga_player.sunits,																-- unitcontroller over player's army
		function() intro_cutscene_end() end,											-- what to call when cutscene is finished
		"script/battle/quest_battles/_cutscene/managers/wh3_bhashiva_qb_intro.CindySceneManager",			-- path to cindyscene
		0,																				-- blend in time (s)
		0																				-- blend out time (s)
	);

	local player_units_hidden = false;

	-- set up subtitles
	local subtitles = cutscene_intro:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();

	cutscene_intro:set_skippable(
		true, 
		function()
			local cam = bm:camera();
			cam:fade(true, 0);
			bm:stop_cindy_playback(true);
			
			if player_units_hidden then
				ga_player:set_enabled(false)
			end;
						
			bm:callback(function() cam:fade(false, 0.2) end, 500);
			bm:hide_subtitles();
		end
	);
	
	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(false, 1) end, 1000);

	cutscene_intro:action(
		function()
			ga_player.sunits:get_general_sunit():set_invisible_to_all(true); -- Makes Dechala invisible so cinematic Dechala has the scene
			--ga_player.sunits:set_invisible_to_all(true)
			player_units_hidden = false;
		end, 
		200
	);	

	
	ogre_tribe_hunter.sunits:set_always_visible_no_hidden_no_leave_battle(true);

	ogre_tribe_bulls.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	ogre_tribe_bullsdual.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	ogre_tribe_maneaterfists.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	ogre_tribe_gnoblarslingers.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	ogre_tribe_leadbelchers.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	ogre_tribe_crushersfists.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	ogre_tribe_crushersgw.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	ogre_tribe_vultures.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	ogre_tribe_stonehorn.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	ogre_tribe_thundertusk.sunits:set_always_visible_no_hidden_no_leave_battle(true);

-- Ogre Attackers --

ogre_prison_guard = gb:get_army(gb:get_non_player_alliance_num(),"ogre_prison_guards");


	--right_evac_point.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	--left_evac_point.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	--centreback_evac_point.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	--centreback_evac_point_art.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	
	--militia_left.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	--militia_right.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	--militia_centre_back.sunits:set_always_visible_no_hidden_no_leave_battle(true);

	-- Voiceover and Subtitles --
	cutscene_intro:action(function() cutscene_intro:play_sound(sfx_cutscene_sweetener_intro_play) end, 0);
	
	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_cp1_cat_Bhashiva_QB_Phase1_01", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_cp1_cat_Bhashiva_QB_Phase1_01"))
				bm:show_subtitle("wh3_cp1_cat_Bhashiva_QB_Phase1_01", false, true)
			end
	)

	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_cp1_cat_Bhashiva_QB_Phase1_02", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_cp1_cat_Bhashiva_QB_Phase1_02"))
				bm:show_subtitle("wh3_cp1_cat_Bhashiva_QB_Phase1_02", false, true)
			end
	)

	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_cp1_cat_Bhashiva_QB_Phase1_03", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_cp1_cat_Bhashiva_QB_Phase1_03"))
				bm:show_subtitle("wh3_cp1_cat_Bhashiva_QB_Phase1_03", false, true)
			end
	)

	cutscene_intro:start()
end;

function intro_cutscene_end()
	--ga_player.sunits:set_invisible_to_all(false)
	play_sound_2D(sfx_cutscene_sweetener_intro_stop)
	ga_player.sunits:get_general_sunit():set_invisible_to_all(false);
	gb.sm:trigger_message("01_intro_cutscene_end")
	bm:hide_subtitles()
end;

-------------------------------------------------------------------------------------------------
------------------------------------- MID CUTSCENE ----------------------------------------------
-------------------------------------------------------------------------------------------------

function play_mid_cutscene()
	bm:camera():fade(true, 0.5)

	bm:callback(function() 
		local cam = bm:camera()
		
		-- REMOVE ME
		cam:fade(false, 2)

		local cutscene_mid = cutscene:new_from_cindyscene(
			"cutscene_mid", 																				-- unique string name for cutscene
			ga_player.sunits,																				-- unitcontroller over player's army
			function() mid_cutscene_end() end,																-- what to call when cutscene is finished
			"script/battle/quest_battles/_cutscene/managers/wh3_bhashiva_qb_mid.CindySceneManager",		-- path to cindyscene
			0,																								-- blend in time (s)
			0																								-- blend out time (s)
		)

		cutscene_mid:action(
			function() 	
				ga_player.sunits:set_invisible_to_all(true)
			end, 
			10
		)

		-- set up subtitles
		local subtitles = cutscene_mid:subtitles()
		subtitles:set_alignment("bottom_centre")
		subtitles:clear()
		
		-- skip callback
		cutscene_mid:set_skippable(
			true, 
			function()
				local cam = bm:camera()
				cam:fade(true, 0)
				bm:stop_cindy_playback(true)
				bm:callback(function() cam:fade(false, 0.5) end, 500)
				bm:hide_subtitles()
			end
		)
		
		-- set up actions on cutscene
		cutscene_mid:action(function() cam:fade(false, 1) end, 1000)

		--fade at the end
		cutscene_mid:action(function() cam:fade(true, 0) end, 82600)

		-- Voiceover and Subtitles --
		cutscene_mid:action(function() cutscene_mid:play_sound(sfx_cutscene_sweetener_mid_play) end, 0);
		
		cutscene_mid:add_cinematic_trigger_listener(
			"Play_wh3_cp1_cat_Bhashiva_QB_Phase2_01", 
				function()
					cutscene_mid:play_sound(new_sfx("Play_wh3_cp1_cat_Bhashiva_QB_Phase2_01"))
					bm:show_subtitle("wh3_cp1_cat_Bhashiva_QB_Phase2_01", false, true)
				end
		)

		cutscene_mid:add_cinematic_trigger_listener(
			"Play_wh3_cp1_cat_Bhashiva_QB_Phase2_02", 
				function()
					cutscene_mid:play_sound(new_sfx("Play_wh3_cp1_cat_Bhashiva_QB_Phase2_02"))
					bm:show_subtitle("wh3_cp1_cat_Bhashiva_QB_Phase2_02", false, true)
				end
		)

		cutscene_mid:add_cinematic_trigger_listener(
			"Play_wh3_cp1_cat_Bhashiva_QB_Phase2_03", 
				function()
					cutscene_mid:play_sound(new_sfx("Play_wh3_cp1_cat_Bhashiva_QB_Phase2_03"))
					bm:show_subtitle("wh3_cp1_cat_Bhashiva_QB_Phase2_03", false, true)
				end
		)

		cutscene_mid:add_cinematic_trigger_listener(
			"Play_wh3_cp1_cat_Bhashiva_QB_Phase2_04", 
				function()
					cutscene_mid:play_sound(new_sfx("Play_wh3_cp1_cat_Bhashiva_QB_Phase2_04"))
					bm:show_subtitle("wh3_cp1_cat_Bhashiva_QB_Phase2_04", false, true)
				end
		)

		cutscene_mid:add_cinematic_trigger_listener(
			"Play_wh3_cp1_cat_Bhashiva_QB_Phase2_05", 
				function()
					cutscene_mid:play_sound(new_sfx("Play_wh3_cp1_cat_Bhashiva_QB_Phase2_05"))
					bm:show_subtitle("wh3_cp1_cat_Bhashiva_QB_Phase2_05", false, true)
				end
		)
		cutscene_mid:add_cinematic_trigger_listener(
			"Play_wh3_cp1_cat_Bhashiva_QB_Phase2_06", 
				function()
					cutscene_mid:play_sound(new_sfx("Play_wh3_cp1_cat_Bhashiva_QB_Phase2_06"))
					bm:show_subtitle("wh3_cp1_cat_Bhashiva_QB_Phase2_06", false, true)
				end
		)
		cutscene_mid:add_cinematic_trigger_listener(
			"Play_wh3_cp1_cat_Bhashiva_QB_Phase2_07", 
				function()
					cutscene_mid:play_sound(new_sfx("Play_wh3_cp1_cat_Bhashiva_QB_Phase2_07"))
					bm:show_subtitle("wh3_cp1_cat_Bhashiva_QB_Phase2_07", false, true)
				end
		)

		cutscene_mid:start()
	end, 1000)
end

function mid_cutscene_end()
	sm:trigger_message("knifey_dead")	
	play_sound_2D(sfx_cutscene_sweetener_mid_stop)
	ga_player.sunits:set_invisible_to_all(false)

end

ga_player = gb:get_army(gb:get_player_alliance_num(), 1); -- Player's army

cathay_captives = gb:get_army(gb:get_player_alliance_num(),"cth_captives");

cathay_reinforcements = gb:get_army(gb:get_player_alliance_num(),"player_ally");

-- Ogre Defenders --

ogre_tribe_slaughtermaster = gb:get_army(gb:get_non_player_alliance_num(),"ogre_defenders_leader");
ogre_tribe_hunter = gb:get_army(gb:get_non_player_alliance_num(),"ogre_defenders_hunter");

ogre_tribe_bulls = gb:get_army(gb:get_non_player_alliance_num(),"ogre_defenders_bull");
ogre_tribe_bullsdual = gb:get_army(gb:get_non_player_alliance_num(),"ogre_defenders_dualbull");
ogre_tribe_maneaterfists = gb:get_army(gb:get_non_player_alliance_num(),"ogre_defenders_maneater_fists");
ogre_tribe_gnoblarslingers = gb:get_army(gb:get_non_player_alliance_num(),"ogre_defenders_gnoblar_flingers");
ogre_tribe_leadbelchers = gb:get_army(gb:get_non_player_alliance_num(),"ogre_defenders_leadbelchers");
ogre_tribe_crushersfists = gb:get_army(gb:get_non_player_alliance_num(),"ogre_defenders_crushers_fists");
ogre_tribe_crushersgw = gb:get_army(gb:get_non_player_alliance_num(),"ogre_defenders_crushers_gw");
ogre_tribe_vultures = gb:get_army(gb:get_non_player_alliance_num(),"ogre_defenders_vultures");
ogre_tribe_stonehorn = gb:get_army(gb:get_non_player_alliance_num(),"ogre_defenders_stonehorn");
ogre_tribe_thundertusk = gb:get_army(gb:get_non_player_alliance_num(),"ogre_defenders_thundertusk");

-- Ogre Attackers --

ogre_prison_guard = gb:get_army(gb:get_non_player_alliance_num(),"ogre_prison_guards");

ogre_tribe_gnoblars = gb:get_army(gb:get_non_player_alliance_num(),"ogre_initial_attack");
ogre_tribe_pigback_riders = gb:get_army(gb:get_non_player_alliance_num(),"ogre_initial_attack");
ogre_tribe_bull_attack = gb:get_army(gb:get_non_player_alliance_num(),"ogre_initial_attack");
ogre_tribe_eshin = gb:get_army(gb:get_non_player_alliance_num(),"ogre_bodyguards");
ogre_tribe_maneatersgw = gb:get_army(gb:get_non_player_alliance_num(),"ogre_attackers_maneaters_gw");
ogre_tribe_dualbulls = gb:get_army(gb:get_non_player_alliance_num(),"ogre_attackers_dualbull");

ogre_tribe_gnoblars.sunits:prevent_rallying_if_routing(true, false, false) -- Prevents the unit from rallying
ogre_tribe_pigback_riders.sunits:prevent_rallying_if_routing(true, false, false) -- Prevents the unit from rallying
ogre_tribe_bull_attack.sunits:prevent_rallying_if_routing(true, false, false) -- Prevents the unit from rallying

-- Dechunga The Wide One --

dechunga_army = gb:get_army(gb:get_non_player_alliance_num(),"dechunga_main_army");

-- -------------------------------------------------------------------------------------------------
-- ---------------------------------------- UNIT TELEPORTS -----------------------------------------
-- -------------------------------------------------------------------------------------------------

-- Ogre Defenders --

ogre_tribe_slaughtermaster.sunits:item(1).uc:teleport_to_location(v(427.9, 306.4), 290, 20) -- 

ogre_tribe_hunter.sunits:item(1).uc:teleport_to_location(v(225.48, 419.14), 5, 20) --

ogre_tribe_bulls.sunits:item(1).uc:teleport_to_location(v(-29.04, 45.23), 180, 30)  --

ogre_tribe_bullsdual.sunits:item(1).uc:teleport_to_location(v(-400.19, 178.63), 120, 30)
ogre_tribe_bullsdual.sunits:item(2).uc:teleport_to_location(v(-416.1, 147.7), 90, 30)  --
ogre_tribe_maneaterfists.sunits:item(1).uc:teleport_to_location(v(459.45, 169.76), 180, 30)  --
ogre_tribe_maneaterfists.sunits:item(2).uc:teleport_to_location(v(429.47, 170.70), 180, 30) --

ogre_tribe_gnoblarslingers.sunits:item(1).uc:teleport_to_location(v(-204.49, 210.00), 180, 40) --
ogre_tribe_gnoblarslingers.sunits:item(2).uc:teleport_to_location(v(-167.79, 199.41), 180, 40) --
ogre_tribe_leadbelchers.sunits:item(1).uc:teleport_to_location(v(8.48, -97.33), 200, 38) --
ogre_tribe_leadbelchers.sunits:item(2).uc:teleport_to_location(v(10.64, -41.14), 210, 38) --
ogre_tribe_leadbelchers.sunits:item(3).uc:teleport_to_location(v(-43.53, -25.58), 220, 38) --

ogre_tribe_crushersfists.sunits:item(1).uc:teleport_to_location(v(194.65, 83.54), 160, 30) --
ogre_tribe_crushersfists.sunits:item(2).uc:teleport_to_location(v(237.39, 103.19), 150, 30) --
ogre_tribe_crushersgw.sunits:item(1).uc:teleport_to_location(v(4.90, 343.94), 200, 20) --

ogre_tribe_vultures.sunits:item(1).uc:teleport_to_location(v(173.09, 395.24), 180, 30) --
ogre_tribe_vultures.sunits:item(2).uc:teleport_to_location(v(215.91, 377.90), 180, 30) --
ogre_tribe_vultures.sunits:item(3).uc:teleport_to_location(v(178.70, 438.45), 180, 30) --

ogre_tribe_stonehorn.sunits:item(1).uc:teleport_to_location(v(218.96, 433.84), 90, 20) --
ogre_tribe_thundertusk.sunits:item(1).uc:teleport_to_location(v(144.85, 414.41), 190, 20) --


-- Ogre Attackers --

ogre_tribe_eshin.sunits:item(1).uc:teleport_to_location(v(440.39, 321.48), 290, 20)
ogre_tribe_eshin.sunits:item(2).uc:teleport_to_location(v(433.92, 296.62), 290, 20)

ogre_tribe_pigback_riders.sunits:item(1).uc:teleport_to_location(v(-84.4, -208.08), 290, 20) 
ogre_tribe_gnoblars.sunits:item(2).uc:teleport_to_location(v(-181.06, -206.16), 290, 20)
ogre_tribe_gnoblars.sunits:item(3).uc:teleport_to_location(v(-207.86, -209.44), 290, 20)
ogre_tribe_gnoblars.sunits:item(4).uc:teleport_to_location(v(-233.92, -212.62), 290, 20)  -- 
ogre_tribe_bull_attack.sunits:item(5).uc:teleport_to_location(v(3.78, -215.37), 290, 20)
ogre_tribe_bull_attack.sunits:item(6).uc:teleport_to_location(v(-42.64, -212.07), 290, 20) -- 

ogre_prison_guard.sunits:item(1).uc:teleport_to_location(v(-248.10, 381.89), 200, 20) -- 
ogre_prison_guard.sunits:item(2).uc:teleport_to_location(v(-277.8, 333.7), 200, 60)
ogre_prison_guard.sunits:item(3).uc:teleport_to_location(v(-188.0, 343.2), 90, 40) 
ogre_prison_guard.sunits:item(4).uc:teleport_to_location(v(-190.6, 390.1), 90, 40) 
ogre_prison_guard.sunits:item(5).uc:teleport_to_location(v(-248.1, 293.4), 200, 40) 
ogre_prison_guard.sunits:item(6).uc:teleport_to_location(v(-315.9, 319.5), 200, 40)

ogre_tribe_maneatersgw.sunits:item(1).uc:teleport_to_location(v(10.25, 156.80), 230, 30)
ogre_tribe_maneatersgw.sunits:item(2).uc:teleport_to_location(v(-11.77, 184.26), 230, 30)
ogre_tribe_maneatersgw.sunits:item(3).uc:teleport_to_location(v(-31.79, 209.23), 230, 30)

ogre_tribe_dualbulls.sunits:item(1).uc:teleport_to_location(v(341.33, -85.77), 230, 60)
ogre_tribe_dualbulls.sunits:item(2).uc:teleport_to_location(v(310.0, -51.1), 210, 60)
ogre_tribe_dualbulls.sunits:item(3).uc:teleport_to_location(v(341.6, -46.9), 230, 60)



cathay_captives.sunits:set_invisible_to_all(true) -- Setting the captives invisible so they can't be seen teleporting.

ogre_tribe_slaughtermaster.sunits:set_stat_attribute("unbreakable", true)

-------------------------------------------------------------------------------------------------
------------------------------------------- WAYPOINTS -------------------------------------------
-------------------------------------------------------------------------------------------------

leadbelcherswaypoint = v(-19.7, 36.0, -143.9) 

dualbullsandcrushersswaypoint = v(245.6, 60.7, -150.3) 

ogre_prison_guard_waypoint = v(-156.5, 77.6, 302.7) 

slingers_bulls_waypoint1 = v(-303.9, 35.2, 154.3) 
slingers_bulls_waypoint2 = v(-2.0, 83.9, 293.7) 

maneaterguardwaypoint = v(395.7, 107.5, 32.8) 

beastspemwaypoint = v(189.2, 106.8, 261.0) 

knifeyhandswaypoint = v(361.1, 156.1, 254.2)

cathayreinwaypoint = v(-479.6, 54.3, 289.0) 

crusherswaypoint1 = v(14.6, 71.1, 205.4) 
crusherswaypoint2 = v(-176.2, 78.3, 367.1)
crusherswaypoint3 = v(211.4, 117.2, 124.4)

maneatergwwaypoint = v(-67.8, 44.4, 61.1)

-- -------------------------------------------------------------------------------------------------
-- ---------------------------------------- ORDERS -------------------------------------------------
-- -------------------------------------------------------------------------------------------------


-- Prison Guards for the secondary side objectives

ga_player:message_on_proximity_to_position("ogre_prison_guard_attack", ogre_prison_guard_waypoint, 150)

gb:queue_help_on_message("ogre_prison_guard_attack", "wh3_cp1_qb_cth_bhashiva_heavens_gate_bhashiva_paymaster_01")

ogre_prison_guard:attack_force_on_message("ogre_prison_guard_attack", ga_player, 1000);


-- Leadbelchers and Bull

ga_player:message_on_proximity_to_position("leadbelchersattack", leadbelcherswaypoint, 85)
ogre_tribe_leadbelchers:attack_force_on_message("leadbelchersattack", ga_player, 1000);
ogre_tribe_bulls:attack_force_on_message("leadbelchersattack", ga_player, 1000);

-- Slingers + bulls near the prison guard

ga_player:message_on_proximity_to_position("slinger_bull_attack", slingers_bulls_waypoint1, 150)
ga_player:message_on_proximity_to_position("slinger_bull_attack", slingers_bulls_waypoint2, 150)

ogre_tribe_gnoblarslingers:attack_force_on_message("slinger_bull_attack", ga_player, 1000);
ogre_tribe_bullsdual:attack_force_on_message("slinger_bull_attack", ga_player, 1000);
ogre_tribe_maneatersgw:attack_force_on_message("slinger_bull_attack", ga_player, 1000);

-- Maneater GW

ga_player:message_on_proximity_to_position("maneatergwattack", maneatergwwaypoint, 90)

ogre_tribe_maneatersgw:attack_force_on_message("maneatergwattack", ga_player, 1000);

-- Maneaters guarding the right point

ga_player:message_on_proximity_to_position("maneaterguardattack", maneaterguardwaypoint, 120)

ogre_tribe_maneaterfists:attack_force_on_message("maneaterguardattack", ga_player, 1000);

-- Dualbuals and Crushers on the right

ga_player:message_on_proximity_to_position("daulbullandcrusherattack", dualbullsandcrushersswaypoint, 120)

ogre_tribe_dualbulls:attack_force_on_message("daulbullandcrusherattack", ga_player, 1000);
ogre_tribe_crushersfists:attack_force_on_message("daulbullandcrusherattack", ga_player, 1000);

-- Crushers (Ironfist and Great Weapons)

ga_player:message_on_proximity_to_position("crushersattack", crusherswaypoint1, 120) -- Waypoint behind the three maneaters with great weapons

ogre_tribe_crushersfists:attack_force_on_message("crushersattack", ga_player, 1000);
ogre_tribe_crushersgw:attack_force_on_message("crushersattack", ga_player, 1000);

ga_player:message_on_proximity_to_position("crusherGWattack", crusherswaypoint2, 120) -- Waypoint in front of the two crushers with iron fists
ogre_tribe_crushersgw:attack_force_on_message("crusherGWattack", ga_player, 1000);

ga_player:message_on_proximity_to_position("crusherGWattack", crusherswaypoint3, 120) -- Waypoint on the right side of the captives
ogre_tribe_crushersgw:attack_force_on_message("crusherGWattack", ga_player, 1000);

-- Beasts pen

ga_player:message_on_proximity_to_position("beastsattack", beastspemwaypoint, 140)

ogre_tribe_stonehorn:attack_force_on_message("beastsattack", ga_player, 1000);
ogre_tribe_thundertusk:attack_force_on_message("beastsattack", ga_player, 1000);
ogre_tribe_hunter:attack_force_on_message("beastsattack", ga_player, 1000);

-- Knifey 'Ands'

ga_player:message_on_proximity_to_position("knifeyattack", knifeyhandswaypoint, 150)

gb:queue_help_on_message("knifeyattack", "wh3_cp1_qb_cth_bhashiva_heavens_gate_bhashiva_knifey_ands_01")

ogre_tribe_slaughtermaster:attack_force_on_message("knifeyattack", ga_player, 1000);
ogre_tribe_eshin:attack_force_on_message("knifeyattack", ga_player, 1000);


-- Cathay reinforcements if the player completes the side objectives

gb:block_message_on_message("prison_guard_dead","side_fail",true) -- Prevents side objective from failing/re-failing
gb:message_on_all_messages_received("cathay_reinforce", "prison_guard_dead", "knifey_dead") 
cathay_reinforcements:reinforce_on_message("cathay_reinforce", 30000)

cathay_reinforcements:message_on_proximity_to_position("cathay_rein_enter", cathayreinwaypoint, 50)
gb:queue_help_on_message("cathay_rein_enter", "wh3_cp1_qb_cth_bhashiva_heavens_gate_bhashiva_op_obj_03_message")

-- -------------------------------------------------------------------------------------------------
-- ---------------------------------------- Objectives ---------------------------------------------
-- -------------------------------------------------------------------------------------------------

gb:message_on_time_offset("start", 1000);

-- Starting dialogue in the quest battle 

gb:message_on_time_offset("starting_message_01", 5000); -- Starting message, Ogres get excited at food
gb:message_on_time_offset("starting_message_02", 15000);  -- Bhashiva response, triggering the Kill "Knifey 'Ands" objective
gb:message_on_time_offset("starting_message_03", 35000);  -- Trigger optional objective

gb:message_on_time_offset("bhashiva_death_hint", 52000); -- Don't let Bhashiva die objective

gb:message_on_time_offset("vulture_attack", 140000); -- Trigger the vultures attacking

gb:queue_help_on_message("starting_message_01", "wh3_cp1_qb_cth_bhashiva_heavens_gate_bhashiva_obj1_01_message") -- Initial Attacking force dialogue
gb:queue_help_on_message("starting_message_02", "wh3_cp1_qb_cth_bhashiva_heavens_gate_bhashiva_obj1_02_message") -- Bhashiva response dialogue, triggering the first objective
gb:set_objective_on_message("starting_message_02", "wh3_cp1_qb_cth_bhashiva_heavens_gate_bhashiva_obj1") -- Kill "Knifey 'Ands" 

gb:queue_help_on_message("starting_message_03", "wh3_cp1_qb_cth_bhashiva_heavens_gate_bhashiva_op_obj_01_message")
gb:set_objective_on_message("starting_message_03", "wh3_cp1_qb_cth_bhashiva_heavens_gate_bhashiva_op_obj")

ogre_tribe_gnoblars:attack_force_on_message("starting_message_01", ga_player, 2000); -- Ogres forces near the player deployment attack Bhashiva
ogre_tribe_pigback_riders:attack_force_on_message("starting_message_01", ga_player, 2000); -- Ogres forces near the player deployment attack Bhashiva
ogre_tribe_bull_attack:attack_force_on_message("starting_message_01", ga_player, 2000); -- Ogres forces near the player deployment attack Bhashiva

ogre_tribe_vultures:attack_force_on_message("vulture_attack", ga_player, 2000);

-- Bhashiva Death Objective

gb:set_objective_on_message("bhashiva_death_hint", "wh3_cp1_qb_cth_bhashiva_heavens_gate_bhashiva_alive")
gb:queue_help_on_message("bhashiva_death_hint", "wh3_cp1_qb_cth_bhashiva_heavens_gate_bhashiva_alive_hint")

-- Complete the side objective

local phase_1_optional_complete_vo = new_sfx("Play_wh3_cp1_cat_Bhashiva_QB_Phase1_Optional_Complete_01", false, true);

ogre_prison_guard:message_on_rout_proportion("prison_guard_dead", 0.6)
ogre_prison_guard:message_on_rout_proportion("side_complete", 0.6)
cathay_captives:rout_over_time_on_message("prison_guard_dead", 1) 
gb:block_message_on_message("prison_guard_dead","side_fail",true)
gb:complete_objective_on_message("prison_guard_dead", "wh3_cp1_qb_cth_bhashiva_heavens_gate_bhashiva_op_obj", 1000)
gb:queue_help_on_message("prison_guard_dead", "wh3_cp1_qb_cth_bhashiva_heavens_gate_bhashiva_op_obj_02_message")
gb:play_sound_on_message("prison_guard_dead", phase_1_optional_complete_vo);

-- Fail the side objective if not completed.

gb:message_on_any_message_received("side_fail", "knifey_dead")

gb:block_message_on_message("side_fail","prison_guard_dead",true)
gb:fail_objective_on_message("side_fail", "wh3_cp1_qb_cth_bhashiva_heavens_gate_bhashiva_op_obj", 1000)
gb:queue_help_on_message("side_fail", "wh3_cp1_qb_cth_bhashiva_heavens_gate_bhashiva_op_obj_fail_message")


gb:add_listener(
	"starting_message_01",
	function()
		cathay_captives.sunits:item(1).uc:teleport_to_location(v(-311.42, 442.13), 200, 20)
		cathay_captives.sunits:item(2).uc:teleport_to_location(v(-322.07, 428.45), 200, 20)
		cathay_captives.sunits:item(3).uc:teleport_to_location(v(-284.39, 456.43), 200, 20)
		cathay_captives.sunits:item(4).uc:teleport_to_location(v(-238.4, 445.9), 200, 20)
		cathay_captives.sunits:item(5).uc:teleport_to_location(v(-333.7, 452.8), 200, 20)
	end
);


gb:add_listener(
	"starting_message_02",
	function()
		ogre_tribe_slaughtermaster:add_ping_icon(15, 1, 10000); -- Adds a ping to the Knifey 'Ands, then removes it after 10s
	end
);

gb:add_listener(
	"starting_message_03",
	function()
		ogre_prison_guard:add_ping_icon(15, 1, 15000); -- Adds a ping to the prison guards, then removes it after 15s
		ogre_prison_guard:add_ping_icon(15, 2, 15000); -- Adds a ping to the prison guards, then removes it after 15s
		ogre_prison_guard:add_ping_icon(15, 3, 15000); -- Adds a ping to the prison guards, then removes it after 15s
		ogre_prison_guard:add_ping_icon(15, 4, 15000); -- Adds a ping to the prison guards, then removes it after 15s
		ogre_prison_guard:add_ping_icon(15, 5, 15000); -- Adds a ping to the prison guards, then removes it after 15s
		ogre_prison_guard:add_ping_icon(15, 6, 15000); -- Adds a ping to the prison guards, then removes it after 15s
		cathay_captives.sunits:set_invisible_to_all(false)
	end
);

gb:add_listener(
    "mid_cutscene",
	function()
		bm:callback(
			function()
				play_mid_cutscene()
			--	sm:trigger_message("clean_up_units")
			end,
			2000
		)
    end
)

-- Enter Dechunga

ogre_tribe_slaughtermaster:message_on_commander_dead_or_routing("mid_cutscene")

ogre_tribe_eshin:rout_over_time_on_message("mid_cutscene", 1) 
ogre_tribe_hunter:rout_over_time_on_message("mid_cutscene", 1) 
ogre_tribe_bulls:rout_over_time_on_message("mid_cutscene", 1) 
ogre_tribe_bullsdual:rout_over_time_on_message("mid_cutscene", 1) 
ogre_tribe_gnoblarslingers:rout_over_time_on_message("mid_cutscene", 1) 
ogre_tribe_leadbelchers:rout_over_time_on_message("mid_cutscene", 1) 
ogre_tribe_maneaterfists:rout_over_time_on_message("mid_cutscene", 1) 
ogre_tribe_crushersgw:rout_over_time_on_message("mid_cutscene", 1) 
ogre_tribe_crushersfists:rout_over_time_on_message("mid_cutscene", 1) 
ogre_tribe_maneatersgw:rout_over_time_on_message("mid_cutscene", 1) 
ogre_tribe_dualbulls:rout_over_time_on_message("mid_cutscene", 1) 
ogre_tribe_thundertusk:rout_over_time_on_message("mid_cutscene", 1) 
ogre_tribe_stonehorn:rout_over_time_on_message("mid_cutscene", 1) 

gb:message_on_any_message_received("side_fail", "knifey_dead")

gb:complete_objective_on_message("knifey_dead", "wh3_cp1_qb_cth_bhashiva_heavens_gate_bhashiva_obj1", 1000)

dechunga_army:reinforce_on_message("knifey_dead", 1000)

gb:set_objective_on_message("knifey_dead", "wh3_cp1_qb_cth_bhashiva_heavens_gate_bhashiva_obj2")

-- -------------------------------------------------------------------------------------------------
-- ---------------------------------------- Victory ------------------------------------------------
-- -------------------------------------------------------------------------------------------------

dechunga_army:message_on_commander_dead_or_routing("dechunga_dead") -- On death, message is created for the garrison commander
gb:queue_help_on_message("dechunga_dead", "wh3_cp1_qb_cth_bhashiva_heavens_gate_bhashiva_obj2_victory") -- Success message
gb:complete_objective_on_message("dechunga_dead", "wh3_cp1_qb_cth_bhashiva_heavens_gate_bhashiva_obj2", 1000) -- Sets the objective as complete

ga_player:force_victory_on_message("dechunga_dead", 16000)
-- -------------------------------------------------------------------------------------------------
-- ---------------------------------------- Defeat -------------------------------------------------
-- -------------------------------------------------------------------------------------------------

ga_player:message_on_commander_dead_or_shattered("bhashiva_dead_or_shattered"); -- 

gb:queue_help_on_message("bhashiva_dead_or_shattered", "wh3_cp1_qb_cth_bhashiva_heavens_gate_bhashiva_alive_defeat") -- Defeat message
gb:fail_objective_on_message("bhashiva_dead_or_shattered", "wh3_cp1_qb_cth_bhashiva_heavens_gate_bhashiva_alive", 1000) -- 
ogre_tribe_slaughtermaster:force_victory_on_message("bhashiva_dead_or_shattered", 16000)