-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Tamurkhan (castellan chieftain devoted battle)
-- Subjugation's Reach
-- dar_infield_a
-- Attacker

load_script_libraries()

gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	true,                                     	-- prevent deployment for ai
	function() play_intro_cutscene() end,      	-- intro cutscene function -- nil, --
	false                                      	-- debug mode
)

wh3_intro_sfx_01 = new_sfx("Play_wh3_dlc25_qb_nur_tamurkhan_chieftain_castellan")
gb:set_cutscene_during_deployment(true)

-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO CUTSCENE -----------------------------------------
-------------------------------------------------------------------------------------------------

function play_intro_cutscene()
	
	local cam = bm:camera()

	cam:fade(false, 1)
	
	ga_playerarmy.sunits:set_always_visible(true)
	ga_enemy_1.sunits:set_always_visible(true)
	ga_enemy_1_lord.sunits:set_always_visible(true)
	ga_enemy_2.sunits:set_always_visible(true)
	ga_enemy_2_left.sunits:set_always_visible(true)
	ga_enemy_2_right.sunits:set_always_visible(true)
	ga_enemy_2_lord.sunits:set_always_visible(true)
	ga_enemy_2_boss.sunits:set_always_visible(true)

	local cutscene_intro = cutscene:new_from_cindyscene(
        -- unique string name for cutscene
        "cutscene_intro",
        -- unitcontroller or scriptunits collection over player's army
        ga_playerarmy.sunits,
        -- end callback
        function() intro_cutscene_end() end,
        -- path to cindy scene
        "script\\battle\\quest_battles\\_cutscene\\managers\\subjugations_reach_m01.CindySceneManager",
        -- optional fade in/fade out durations
        0,
        2
	)

	-- skip callback
	cutscene_intro:set_skippable(
		true, 
		function()
			bm:stop_cindy_playback(true)
		end
	)

	-- set up subtitles
	local subtitles = cutscene_intro:subtitles()
	subtitles:set_alignment("bottom_centre")
	subtitles:clear()
	
	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc25_qb_nur_tamurkhan_chieftain_castellan", 
			function()
				cutscene_intro:play_sound(wh3_intro_sfx_01)
				bm:show_subtitle("wh3_dlc25_qb_nur_tamurkhan_chieftain_castellan", false, true)
			end
	)

	cutscene_intro:start()
end

function intro_cutscene_end()
	bm:hide_subtitles()
end


-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

--friendly factions
ga_playerarmy = gb:get_army(gb:get_player_alliance_num(), 1)

--enemy faction
ga_enemy_1 = gb:get_army(gb:get_non_player_alliance_num(),"enemy_1")
ga_enemy_1_lord = gb:get_army(gb:get_non_player_alliance_num(),"enemy_1_lord")
ga_enemy_2 = gb:get_army(gb:get_non_player_alliance_num(),"enemy_2")
ga_enemy_2_left = gb:get_army(gb:get_non_player_alliance_num(),"enemy_2_left")
ga_enemy_2_right = gb:get_army(gb:get_non_player_alliance_num(),"enemy_2_right")
ga_enemy_2_lord = gb:get_army(gb:get_non_player_alliance_num(),"enemy_2_lord")
ga_enemy_2_boss = gb:get_army(gb:get_non_player_alliance_num(),"enemy_2_boss")

------------------------------------------------------------------------------------------------
-------------------------------------------- CO-ORDINATES/TELEPORT ------------------------------
-------------------------------------------------------------------------------------------------
function teleport_units()
	-- Characters & Idol
	ga_enemy_1_lord.sunits:item(1).uc:teleport_to_location(v(-500, -450), 127.3144, 1.1) 	
	ga_enemy_2_lord.sunits:item(1).uc:teleport_to_location(v(-425, -290), 180, 1.1) 
	ga_enemy_2_boss.sunits:item(1).uc:teleport_to_location(v(-450, -225), 167.3144, 8) 

	--Enemy 1 main
	ga_enemy_1.sunits:item(1).uc:teleport_to_location(v(-397, -460), 180, 41.5)
	ga_enemy_1.sunits:item(2).uc:teleport_to_location(v(-510, -460),180, 41.5)
	ga_enemy_1.sunits:item(3).uc:teleport_to_location(v(-620, -460),180, 41.5)
	ga_enemy_1.sunits:item(4).uc:teleport_to_location(v(-436, -460),180, 26.7)
	ga_enemy_1.sunits:item(5).uc:teleport_to_location(v(-465, -460),180, 26.7)
	ga_enemy_1.sunits:item(6).uc:teleport_to_location(v(-549, -460),180, 26.7)
	ga_enemy_1.sunits:item(7).uc:teleport_to_location(v(-577.5, -460),180, 26.7)
	ga_enemy_1.sunits:item(8).uc:teleport_to_location(v(-403, -395),180, 40)
	ga_enemy_1.sunits:item(9).uc:teleport_to_location(v(-512, -395),180, 40)
	ga_enemy_1.sunits:item(10).uc:teleport_to_location(v(-590, -395),180, 40)
	ga_enemy_1.sunits:item(11).uc:teleport_to_location(v(-420, -430),180, 38.4)
	ga_enemy_1.sunits:item(12).uc:teleport_to_location(v(-480, -430),180, 38.4)
	ga_enemy_1.sunits:item(13).uc:teleport_to_location(v(-540, -430),180, 38.4)
	ga_enemy_1.sunits:item(14).uc:teleport_to_location(v(-400, -445.5),180, 8)
	ga_enemy_1.sunits:item(15).uc:teleport_to_location(v(-560, -445.5),180, 8)

	--  Enemy 2 Defence 
	ga_enemy_2.sunits:item(1).uc:teleport_to_location(v(-379, -280), 180, 41.5) 
	ga_enemy_2.sunits:item(2).uc:teleport_to_location(v(-448, -280), 180, 41.5) 
	ga_enemy_2.sunits:item(3).uc:teleport_to_location(v(-490, -280), 180, 41.5)
	ga_enemy_2.sunits:item(4).uc:teleport_to_location(v(-566, -280), 180, 41.5)
	ga_enemy_2.sunits:item(5).uc:teleport_to_location(v(-403, -242), 180, 41.5) 
	ga_enemy_2.sunits:item(6).uc:teleport_to_location(v(-473, -249), 180, 41.5) 
	ga_enemy_2.sunits:item(7).uc:teleport_to_location(v(-542, -242), 180, 41.5) 
	ga_enemy_2.sunits:item(8).uc:teleport_to_location(v(-413.5, -280), 180, 32.4) 
	ga_enemy_2.sunits:item(9).uc:teleport_to_location(v(-527.4, -280), 180, 32.4) 

	-- Enemy 2 left flank
	ga_enemy_2_left.sunits:item(1).uc:teleport_to_location(v(-90, -477), 180, 40)
	ga_enemy_2_left.sunits:item(2).uc:teleport_to_location(v(-132, -477), 180, 40)
	ga_enemy_2_left.sunits:item(3).uc:teleport_to_location(v(-174, -477), 180, 40)
	ga_enemy_2_left.sunits:item(4).uc:teleport_to_location(v(-112, -446), 180, 40)

	-- Enemy 2 right flank
	ga_enemy_2_right.sunits:item(1).uc:teleport_to_location(v(-854, -506), 180, 40)
	ga_enemy_2_right.sunits:item(2).uc:teleport_to_location(v(-896, -506), 180, 40)
	ga_enemy_2_right.sunits:item(3).uc:teleport_to_location(v(-942, -506), 180, 40)
	ga_enemy_2_right.sunits:item(4).uc:teleport_to_location(v(-878, -472), 180, 40)

end

------------------------------------------------------------------------------------
---------------------------------- ORDERS ------------------------------------------
------------------------------------------------------------------------------------
teleport_units()

ga_enemy_1_lord:add_winds_of_magic_on_message("battle_started", 50)
ga_enemy_2_lord:add_winds_of_magic_on_message("battle_started", 50)

gb:message_on_time_offset("battle_started", 5)

ga_enemy_2_left:rush_on_message("battle_started", 50)
ga_enemy_2_right:rush_on_message("battle_started", 50)

--release first wave when player approaches
ga_enemy_1:rush_on_message("release_wave_1")
ga_enemy_1_lord:release_on_message("release_wave_1")

--release second wave when player appproaches or kills first wave
ga_enemy_2:release_on_message("release_wave_2")
ga_enemy_2_lord:release_on_message("release_wave_2")
ga_enemy_2_boss:release_on_message("release_wave_2")


--messages to fire
ga_playerarmy:message_on_proximity_to_position("release_wave_1", v(-500, -450), 200)
ga_playerarmy:message_on_proximity_to_position("release_wave_2", v(-425, -290), 250)
ga_playerarmy:message_on_proximity_to_position("release_boss", v(-425, -290), 450)

ga_enemy_1:message_on_rout_proportion("release_wave_1", 0.95)
ga_enemy_1:message_on_rout_proportion("release_wave_2", 0.5)
ga_enemy_2:message_on_rout_proportion("release_wave_2", 0.95)
ga_enemy_2_lord:message_on_under_attack("release_wave_2")
ga_enemy_2_boss:message_on_under_attack("release_boss")


ga_enemy_1_lord:message_on_commander_dead_or_routing("lord_1_defeated")
ga_enemy_2_lord:message_on_commander_dead_or_routing("lord_2_defeated")
gb:message_on_all_messages_received("lords_defeated", "lord_1_defeated", "lord_2_defeated")
gb:message_on_all_messages_received("victory", "idol_defeated", "lords_defeated")


--boss killed function
if ga_enemy_2_boss then
	bm:watch(
		function()
			return is_shattered_or_dead(ga_enemy_2_boss.sunits:item(1))
		end,
		0,
		function()
			bm:out("*** boss is shattered or dead! ***")
			gb.sm:trigger_message("idol_defeated")
			ga_playerarmy:play_sound_charge()	--adds a charge/cheer sound effect when the unit dies
			bm:queue_help_message("wh3_dlc25_qb_nur_tamurkhan_chieftain_castellan_hint_04", 8000, 2000, true)
		end
	)
end

----------------------------------------------------------------------------------------
---------------------------------- OBJECTIVES ------------------------------------------
----------------------------------------------------------------------------------------

gb:add_listener("battle_started", function() hint_1() end)
gb:add_listener("hint_2", function() hint_2() end)

function hint_1()
	ga_enemy_2_boss.sunits:item(1):add_ping_icon(15)
	bm:set_objective("wh3_dlc25_qb_nur_tamurkhan_chieftain_castellan_objective_01")
	bm:set_objective("wh3_dlc25_qb_nur_tamurkhan_chieftain_survive_objective_01")
	bm:queue_help_message("wh3_dlc25_qb_nur_tamurkhan_chieftain_castellan_hint_01", 8000, 2000)
	gb:message_on_time_offset("hint_2", 15000)
end

function hint_2()
	ga_enemy_1_lord.sunits:item(1):add_ping_icon(5)
	ga_enemy_2_lord.sunits:item(1):add_ping_icon(5)	
	bm:set_objective("wh3_dlc25_qb_nur_tamurkhan_chieftain_castellan_objective_02")
	bm:queue_help_message("wh3_dlc25_qb_nur_tamurkhan_chieftain_castellan_hint_02", 8000, 2000)
	bm:queue_help_message("wh3_dlc25_qb_nur_tamurkhan_chieftain_castellan_hint_03", 8000, 2000)

end


-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------

--victory
gb:complete_objective_on_message("idol_defeated", "wh3_dlc25_qb_nur_tamurkhan_chieftain_castellan_objective_01", 500)
gb:complete_objective_on_message("lords_defeated", "wh3_dlc25_qb_nur_tamurkhan_chieftain_castellan_objective_02", 500)
ga_playerarmy:force_victory_on_message("victory", 10000)

--defeat
ga_playerarmy:message_on_commander_death("lord_dead", 1)
ga_playerarmy:message_on_casualties("lord_dead", 1)
ga_playerarmy:rout_over_time_on_message("lord_dead", 10000)
gb:fail_objective_on_message("lord_dead","wh3_dlc25_qb_nur_tamurkhan_chieftain_survive_objective_01")
ga_enemy2:force_victory_on_message("lord_dead", 10000)
gb:queue_help_on_message("lord_dead", "wh3_dlc25_qb_nur_tamurkhan_chieftain_death_hint_01", 8000, 2000, 1000, true)


