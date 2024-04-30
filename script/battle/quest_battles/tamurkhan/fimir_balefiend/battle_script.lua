-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Tamurkhan (fimir balefiend chieftain devoted battle)
-- Dreams of the Urfather
-- nurgle_realm
-- Attacker

load_script_libraries()

gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	true,                                     	-- prevent deployment for ai
	function() play_intro_cutscene() end,      	-- intro cutscene function -- nil, --
	false                                      	-- debug mode
)

wh3_intro_sfx_01 = new_sfx("Play_wh3_dlc25_qb_nur_tamurkhan_chieftain_fimir_balefiend")
gb:set_cutscene_during_deployment(true)

-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO CUTSCENE -----------------------------------------
-------------------------------------------------------------------------------------------------

function play_intro_cutscene()
	
	local cam = bm:camera()

	cam:fade(false, 1)

	ga_playerarmy.sunits:set_always_visible(true)
	ga_enemy1.sunits:set_always_visible(true)
	ga_enemy2.sunits:set_always_visible(true)
	ga_enemy2_lord.sunits:set_always_visible(true)
	ga_enemy3.sunits:set_always_visible(true)
	ga_enemy3_lord.sunits:set_always_visible(true)

	local cutscene_intro = cutscene:new_from_cindyscene(
        -- unique string name for cutscene
        "cutscene_intro",
        -- unitcontroller or scriptunits collection over player's army
        ga_playerarmy.sunits,
        -- end callback
        function() intro_cutscene_end() end,
        -- path to cindy scene
        "script\\battle\\quest_battles\\_cutscene\\managers\\dreams_of_the_urfather_m01.CindySceneManager",
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
		"Play_wh3_dlc25_qb_nur_tamurkhan_chieftain_fimir_balefiend", 
			function()
				cutscene_intro:play_sound(wh3_intro_sfx_01)
				bm:show_subtitle("wh3_dlc25_qb_nur_tamurkhan_chieftain_fimir_balefiend", false, true)
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
ga_enemy1 = gb:get_army(gb:get_non_player_alliance_num(),"enemy_1")
ga_enemy2 = gb:get_army(gb:get_non_player_alliance_num(),"enemy_2")
ga_enemy2_lord = gb:get_army(gb:get_non_player_alliance_num(),"enemy_2_lord")
ga_enemy3 = gb:get_army(gb:get_non_player_alliance_num(),"enemy_3")
ga_enemy3_lord = gb:get_army(gb:get_non_player_alliance_num(),"enemy_3_lord")

enemy_spawn_zone_tze = bm:get_spawn_zone_collection_by_name("RFL_1")
enemy_spawn_zone_sla = bm:get_spawn_zone_collection_by_name("RFL_2")

ga_enemy2:assign_to_spawn_zone_from_collection_on_message("battle_started", enemy_spawn_zone_tze, false)
ga_enemy3:assign_to_spawn_zone_from_collection_on_message("battle_started", enemy_spawn_zone_sla, false)

ga_playerarmy.sunits:item(1):set_stat_attribute("unbreakable", true)
-------------------------------------------------------------------------------------------------
---------------------------------- ORDERS & OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------
final_obj_time = 600

--release armies and make enemy charge player
gb:message_on_time_offset("battle_started", 1000)

ga_playerarmy:release_on_message("battle_started")
ga_enemy1:release_on_message("battle_started", 1000)
ga_enemy1:rush_on_message("battle_started", 2000)

ga_enemy2:release_on_message("battle_started", 151000)
ga_enemy2_lord:release_on_message("battle_started", 151000)
ga_enemy2:rush_on_message("battle_started", 152000)
ga_enemy2_lord:rush_on_message("battle_started", 152000)

ga_enemy3:release_on_message("wave_2", 1000)
ga_enemy3_lord:release_on_message("wave_2", 1000)
ga_enemy3:rush_on_message("wave_2", 2000)
ga_enemy3_lord:rush_on_message("wave_2", 2000)
ga_enemy3_lord:attack_force_on_message("wave_2", ga_playerarmy)

--reinforcements
ga_enemy2_lord:reinforce_on_message("battle_started", 150000);
ga_enemy2:deploy_at_random_intervals_on_message(
		"battle_started", -- message
		3, -- min units
		4, -- max units
		150000, -- min period
		155000, -- max period
		"stop_reinforcements", -- cancel message
		false, -- spawn first wave immediately
		true, -- allow respawning
		nil, -- survival battle wave index
		nil, -- is final survival wave
		false -- show debug output
)
ga_enemy3_lord:reinforce_on_message("reinforcements", 2000);
ga_enemy3:deploy_at_random_intervals_on_message(
		"reinforcements", -- message
		3, -- min units
		4, -- max units
		2000, -- min period
		7000, -- max period
		"stop_reinforcements", -- cancel message
		true, -- spawn first wave immediately
		true, -- allow respawning
		nil, -- survival battle wave index
		nil, -- is final survival wave
		false -- show debug output
)

gb:message_on_time_offset("reinforcements", 210000, "battle_started")
gb:message_on_time_offset("stop_reinforcements", 600000, "battle_started")
gb:message_on_time_offset("wave_2", 2000, "reinforcements")


gb:add_listener(
	"battle_started",
	function()
		bm:set_objective("wh3_dlc25_qb_nur_tamurkhan_chieftain_fimir_objective_02", final_obj_time)
		bm:repeat_callback(
			function()
				final_obj_time = final_obj_time - 1
				if final_obj_time <= 0 then
					-- end battle
					sm:trigger_message("stop_reinforcements")
					sm:trigger_message("victory")
					bm:remove_callback("end_countdown")
				else
				bm:set_objective("wh3_dlc25_qb_nur_tamurkhan_chieftain_fimir_objective_02", final_obj_time)
				end
			end,
			1000,
			"end_countdown"
		)
	end
)

bm:watch(
	function()
		return is_shattered_or_dead(ga_playerarmy.sunits:item(1))
	end,
	0,
	function()
		bm:queue_help_message("wh3_dlc25_qb_nur_tamurkhan_chieftain_death_hint_02", 8000, 2000)
	end
)

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------


gb:queue_help_on_message("battle_started", "wh3_dlc25_qb_nur_tamurkhan_chieftain_fimir_hint_01", 8000, 3000, 1000)
gb:queue_help_on_message("battle_started", "wh3_dlc25_qb_nur_tamurkhan_chieftain_fimir_hint_02", 8000, 3000, 2000)
gb:queue_help_on_message("battle_started", "wh3_dlc25_qb_nur_tamurkhan_chieftain_fimir_hint_07", 8000, 3000, 2000)
gb:queue_help_on_message("battle_started", "wh3_dlc25_qb_nur_tamurkhan_chieftain_fimir_hint_03", 8000, 3000, 1000)


gb:queue_help_on_message("reinforcements", "wh3_dlc25_qb_nur_tamurkhan_chieftain_fimir_hint_04", 8000, 2000, 3000)
gb:queue_help_on_message("battle_started", "wh3_dlc25_qb_nur_tamurkhan_chieftain_fimir_hint_05", 8000, 2000, 480000)
gb:queue_help_on_message("victory", "wh3_dlc25_qb_nur_tamurkhan_chieftain_fimir_hint_06", 8000, 2000, 1000)

--lord must survive
gb:set_objective_on_message("battle_started","wh3_dlc25_qb_nur_tamurkhan_chieftain_survive_objective_01")
gb:complete_objective_on_message("victory", "wh3_dlc25_qb_nur_tamurkhan_chieftain_survive_objective_01", 7000)

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------
ga_playerarmy:force_victory_on_message("victory", 12000)
ga_enemy1:rout_over_time_on_message("victory", 15000)
ga_enemy2:rout_over_time_on_message("victory", 15000)
ga_enemy2_lord:rout_over_time_on_message("victory", 5000)
ga_enemy3:rout_over_time_on_message("victory", 15000)
ga_enemy3_lord:rout_over_time_on_message("victory", 5000)
gb:complete_objective_on_message("victory", "wh3_dlc25_qb_nur_tamurkhan_chieftain_fimir_objective_02", 5000)

------------------------------------------------------------------------
------------------------ PLAYER FORCE DEFEATED -------------------------
------------------------------------------------------------------------
ga_playerarmy:message_on_commander_death("lord_dead", 1)
ga_playerarmy:message_on_casualties("lord_dead", 1)
ga_playerarmy:rout_over_time_on_message("lord_dead", 10000)
gb:fail_objective_on_message("lord_dead","wh3_dlc25_qb_nur_tamurkhan_chieftain_survive_objective_01")
ga_enemy2:force_victory_on_message("lord_dead", 10000)