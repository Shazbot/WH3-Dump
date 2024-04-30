-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Tammurkhan 
-- Chieftain - Exalted Hero
-- Attacker

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------
load_script_libraries();
bm = battle_manager:new(empire_battle:new());

gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	true,                                     	-- prevent deployment for ai
	function() play_intro_cutscene() end,      	-- intro cutscene function -- nil, --
	false                                      	-- debug mode
)

wh3_intro_sfx_01 = new_sfx("Play_wh3_dlc25_qb_nur_tamurkhan_chieftain_exalted_hero")
gb:set_cutscene_during_deployment(true)

-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO CUTSCENE -----------------------------------------
-------------------------------------------------------------------------------------------------

function play_intro_cutscene()
	
	local cam = bm:camera()

	cam:fade(false, 1)
	
	enemy_armies.krom_elites.army.sunits:set_always_visible(true)
	enemy_armies.krom_first_force.army.sunits:set_always_visible(true)
	enemy_armies.krom_flank_force.army.sunits:set_always_visible(true)

	local cutscene_intro = cutscene:new_from_cindyscene(
        -- unique string name for cutscene
        "cutscene_intro",
        -- unitcontroller or scriptunits collection over player's army
        friendly_armies.tammy.army.sunits,
        -- end callback
        function() intro_cutscene_end() end,
        -- path to cindy scene
        "script\\battle\\quest_battles\\_cutscene\\managers\\a_clash_of_rivals_m01.CindySceneManager",
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
		"Play_wh3_dlc25_qb_nur_tamurkhan_chieftain_exalted_hero", 
			function()
				cutscene_intro:play_sound(wh3_intro_sfx_01)
				bm:show_subtitle("wh3_dlc25_qb_nur_tamurkhan_chieftain_exalted_hero", false, true)
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

friendly_armies = {
	tammy = {army= gb:get_army(gb:get_player_alliance_num(), ""), spawn_zone = nil, defeated_message = "tammurkhan_defeated"}
}
enemy_armies = {
	krom_elites = {army= gb:get_army(gb:get_non_player_alliance_num(), "chieftain_elites"), defeated_message= "defeated"},
	krom_first_force = {army= gb:get_army(gb:get_non_player_alliance_num(), "enemy_chaff")},
	krom_flank_force = {army= gb:get_army(gb:get_non_player_alliance_num(), "enemy_chaff_flank")},
}

------------------------------------------------------------------------------------------------
-------------------------------------------- CO-ORDINATES/TELEPORT ------------------------------
-------------------------------------------------------------------------------------------------
function teleport_units()
	-- Lord & elite force
enemy_armies.krom_elites.army.sunits:item(1).uc:teleport_to_location(v(-40.39, 194.03), 171.3144, 25) 
enemy_armies.krom_elites.army.sunits:item(2).uc:teleport_to_location(v(-12.90, 193.32),171.3144, 25)
enemy_armies.krom_elites.army.sunits:item(3).uc:teleport_to_location(v(83.07, 201.80), 171.3144, 25)
enemy_armies.krom_elites.army.sunits:item(4).uc:teleport_to_location(v(-139.47, 182.07), 171.3144, 25)
enemy_armies.krom_elites.army.sunits:item(5).uc:teleport_to_location(v(-205.16, 176.27), 171.3144, 25)
enemy_armies.krom_elites.army.sunits:item(6).uc:teleport_to_location(v(-238.01, 173.36), 171.3144, 25)
enemy_armies.krom_elites.army.sunits:item(7).uc:teleport_to_location(v(-69.29, 188.27), 171.3144, 25)
enemy_armies.krom_elites.army.sunits:item(8).uc:teleport_to_location(v(-172.32, 179.17), 171.3144, 25)
enemy_armies.krom_elites.army.sunits:item(9).uc:teleport_to_location(v(-105.45, 185.07), 171.3144, 25)
enemy_armies.krom_elites.army.sunits:item(10).uc:teleport_to_location(v(-271.83, 170.38), 171.3144, 25)
enemy_armies.krom_elites.army.sunits:item(11).uc:teleport_to_location(v(51.03, 198.90), 171.3144, 25)
enemy_armies.krom_elites.army.sunits:item(12).uc:teleport_to_location(v(19.15, 196.08), 171.3144, 25)
enemy_armies.krom_elites.army.sunits:item(13).uc:teleport_to_location(v(-98.24, 225.21), 171.3144, 25)
enemy_armies.krom_elites.army.sunits:item(14).uc:teleport_to_location(v(-40.39, 224.03), 171.3144, 25)
enemy_armies.krom_elites.army.sunits:item(15).uc:teleport_to_location(v(-22.7, 236.03), 171.3144, 3)

--  Chaff army 
enemy_armies.krom_first_force.army.sunits:item(1).uc:teleport_to_location(v(-138.84, 26.54), 171.3144, 3.06) 
enemy_armies.krom_first_force.army.sunits:item(2).uc:teleport_to_location(v(-54.30, 16.24), 171.3144, 25) 
enemy_armies.krom_first_force.army.sunits:item(3).uc:teleport_to_location(v(-140.48,5.50),171.3144, 25)
enemy_armies.krom_first_force.army.sunits:item(4).uc:teleport_to_location(v(-183.58, 0.17), 171.3144, 25)
enemy_armies.krom_first_force.army.sunits:item(5).uc:teleport_to_location(v(-97.39,10.92), 171.3144, 25)
enemy_armies.krom_first_force.army.sunits:item(6).uc:teleport_to_location(v(-226.69, -5.25), 171.3144, 25)
enemy_armies.krom_first_force.army.sunits:item(7).uc:teleport_to_location(v(31.81, 26.98), 171.3144, 25)
enemy_armies.krom_first_force.army.sunits:item(8).uc:teleport_to_location(v(-11.25, 21.61), 171.3144, 25)
enemy_armies.krom_first_force.army.sunits:item(9).uc:teleport_to_location(v(-269.52, -9.28), 171.3144, 25)
enemy_armies.krom_first_force.army.sunits:item(10).uc:teleport_to_location(v(-53.38, 29.69), 171.3144, 25)
enemy_armies.krom_first_force.army.sunits:item(11).uc:teleport_to_location(v(-179.32, 29.70), 171.3144, 25)
enemy_armies.krom_first_force.army.sunits:item(12).uc:teleport_to_location(v(-138.84, 26.54), 171.3144, 25)

-- Chaff flank
enemy_armies.krom_flank_force.army.sunits:item(1).uc:teleport_to_location(v(288.36, -2.16), 171.3144, 25)
enemy_armies.krom_flank_force.army.sunits:item(2).uc:teleport_to_location(v(318.10, -4.53), 171.3144, 25)
enemy_armies.krom_flank_force.army.sunits:item(3).uc:teleport_to_location(v(296.36, -27.16), 171.3144, 25)
enemy_armies.krom_flank_force.army.sunits:item(4).uc:teleport_to_location(v(329.36, -22.16), 171.3144, 25)

end
teleport_units()
-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------
gb:message_on_time_offset("begin", 1000)
enemy_armies.krom_first_force.army:release_on_message("begin",500)
enemy_armies.krom_first_force.army:rush_on_message("begin",1000)

enemy_armies.krom_flank_force.army:release_on_message("begin",500)
enemy_armies.krom_flank_force.army:rush_on_message("begin",1000)

enemy_armies.krom_first_force.army:add_winds_of_magic_on_message("begin", 25)
enemy_armies.krom_first_force.army:message_on_rout_proportion("chaff_weakened", 0.5)

enemy_armies.krom_elites.army:message_on_under_attack("elites_under_attack")
enemy_armies.krom_elites.army:rush_on_message("elites_under_attack", 500)
enemy_armies.krom_elites.army:rush_on_message("chaff_weakened", 500)

-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------
gb:set_objective_on_message("hint_1","wh3_dlc25_qb_chd_tamurkhan_chieftain_survive_objective_01")
gb:set_objective_on_message("hint_2","wh3_dlc25_qb_chd_tamurkhan_chieftain_exalted_objective_02")

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------
gb:message_on_time_offset("hint_1", 5000)
gb:message_on_time_offset("hint_2", 10000)

gb:queue_help_on_message("hint_1", "wh3_dlc25_qb_chd_tamurkhan_chieftain_exalted_hint_01", 10000);
gb:queue_help_on_message("hint_2", "wh3_dlc25_qb_chd_tamurkhan_chieftain_exalted_hint_02", 10000);
gb:queue_help_on_message(enemy_armies.krom_elites.defeated_message, "wh3_dlc25_qb_chd_tamurkhan_chieftain_exalted_hint_03", 10000);

-------------------------------------------------------------------------------------------------
--------------------------------------------- Icons ---------------------------------------------
-------------------------------------------------------------------------------------------------
enemy_armies.krom_elites.army:add_ping_icon_on_message("hint_2",15,1)

-------------------------------------------------------------------------------------------------
--------------------------------------------- DEFEAT ----------------------------------------------
-------------------------------------------------------------------------------------------------
--- Tammurkhan Dead 
friendly_armies.tammy.army:message_on_commander_dead_or_shattered(friendly_armies.tammy.defeated_message)
gb:fail_objective_on_message(friendly_armies.tammy.defeated_message,"wh3_dlc25_qb_chd_tamurkhan_chieftain_survive_objective_01")
enemy_armies.krom_elites.army:force_victory_on_message(friendly_armies.tammy.defeated_message, 10000)

---player defeated
friendly_armies.tammy.army:message_on_casualties("player_dead", 1)
enemy_armies.krom_elites.army:force_victory_on_message("player_dead", 18000)

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY ----------------------------------------------
-------------------------------------------------------------------------------------------------
--- defeated enemy
enemy_armies.krom_elites.army:message_on_commander_dead_or_shattered(enemy_armies.krom_elites.defeated_message)
gb:complete_objective_on_message(enemy_armies.krom_elites.defeated_message,"wh3_dlc25_qb_chd_tamurkhan_chieftain_exalted_objective_02")

--defeat rest of enemy forces (if applicable)
gb:set_objective_on_message(enemy_armies.krom_elites.defeated_message,"wh3_dlc25_qb_chd_tamurkhan_chieftain_exalted_objective_03")

