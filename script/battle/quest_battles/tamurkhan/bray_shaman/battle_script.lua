-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Tamurkhan (bray shaman chieftain devoted battle)
-- Surviving Hexensnacht
-- wef_hills_infield_g
-- Attacker

load_script_libraries()

gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	true,                                     	-- prevent deployment for ai
	function() play_intro_cutscene() end,      	-- intro cutscene function -- nil, --
	false                                      	-- debug mode
)

wh3_intro_sfx_01 = new_sfx("Play_wh3_dlc25_qb_nur_tamurkhan_chieftain_bray_shaman")
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
	ga_enemy3.sunits:set_always_visible(true)
	
	local cutscene_intro = cutscene:new_from_cindyscene(
        -- unique string name for cutscene
        "cutscene_intro",
        -- unitcontroller or scriptunits collection over player's army
        ga_playerarmy.sunits,
        -- end callback
        function() intro_cutscene_end() end,
        -- path to cindy scene
        "script\\battle\\quest_battles\\_cutscene\\managers\\surviving_hexensnacht_m01.CindySceneManager",
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
		"Play_wh3_dlc25_qb_nur_tamurkhan_chieftain_bray_shaman", 
			function()
				cutscene_intro:play_sound(wh3_intro_sfx_01)
				bm:show_subtitle("wh3_dlc25_qb_nur_tamurkhan_chieftain_bray_shaman", false, true)
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

--friendly faction
ga_playerarmy = gb:get_army(gb:get_player_alliance_num(), 1)

--enemy faction
ga_enemy1 = gb:get_army(gb:get_non_player_alliance_num(),"enemy_1")
ga_enemy2 = gb:get_army(gb:get_non_player_alliance_num(),"enemy_2")
ga_enemy3 = gb:get_army(gb:get_non_player_alliance_num(),"enemy_3")

--defining bosses in script
shaman_1_sunit = ga_enemy1.sunits:get_sunit_by_type("wh2_twa04_bst_cha_great_bray_shaman_wild_0")
shaman_2_sunit = ga_enemy2.sunits:get_sunit_by_type("wh2_twa04_bst_cha_great_bray_shaman_beasts_0")
shaman_3_sunit = ga_enemy3.sunits:get_sunit_by_type("wh2_twa04_bst_cha_great_bray_shaman_shadows_0")

kill_count = 0

-------------------------------------------------------------------------------------------------
---------------------------------- ORDERS & OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------

--Wave functions - enable each wave and apply ojective markers, fire hints and objectives
gb:add_listener("battle_started", function() ping1() end)
function ping1()
	shaman_1_sunit:add_ping_icon(15)
	bm:set_objective("wh3_dlc25_qb_nur_tamurkhan_chieftain_survive_objective_01")
	bm:set_objective("wh3_dlc25_qb_nur_tamurkhan_chieftain_beastman_objective_02", kill_count, 3)
	bm:queue_help_message("wh3_dlc25_qb_nur_tamurkhan_chieftain_beastman_hint_01", 8000, 2000)
	bm:queue_help_message("wh3_dlc25_qb_nur_tamurkhan_chieftain_beastman_hint_02", 8000, 2000)
	bm:queue_help_message("wh3_dlc25_qb_nur_tamurkhan_chieftain_beastman_hint_03", 8000, 2000)
	bm:queue_help_message("wh3_dlc25_qb_nur_tamurkhan_chieftain_beastman_hint_04", 8000, 2000)
	
	bm:out(">>>PING1<<<")
end

gb:message_on_time_offset("charge", 5000)
gb:message_on_time_offset("wave3_reinforce", 60000)
gb:message_on_time_offset("wave3", 65000)
gb:message_on_time_offset("wave3_charge", 65000)

gb:add_listener("battle_started", function() ping2() end)
function ping2()
	shaman_2_sunit:add_ping_icon(15)
	
	bm:out(">>>PING2<<<")
end

gb:add_listener("wave3", function() ping3() end)
function ping3()
	shaman_3_sunit:add_ping_icon(15)
	
	bm:out(">>>PING3<<<")
end

--Shaman kill functions, trigger waves and send messages for victory
if shaman_1_sunit then
	bm:watch(
		function()
			return is_shattered_or_dead(shaman_1_sunit)
		end,
		0,
		function()
			bm:out("*** shaman_1_sunit is shattered or dead! ***")
			kill_count = kill_count + 1
			bm:set_objective("wh3_dlc25_qb_nur_tamurkhan_chieftain_beastman_objective_02", kill_count, 3)

			gb.sm:trigger_message("wave1_dead")
			ga_playerarmy:play_sound_charge()					--adds a charge/cheer sound effect when the unit dies
		end
	)
end

if shaman_2_sunit then
	bm:watch(
		function()
			return is_shattered_or_dead(shaman_2_sunit)
		end,
		0,
		function()
			bm:out("*** shaman_2_sunit is shattered or dead! ***")
			kill_count = kill_count + 1
			bm:set_objective("wh3_dlc25_qb_nur_tamurkhan_chieftain_beastman_objective_02", kill_count, 3)

			gb.sm:trigger_message("wave2_dead")
			ga_playerarmy:play_sound_charge()					--adds a charge/cheer sound effect when the unit dies
		end
	)
end

if shaman_3_sunit then
	bm:watch(
		function()
			return is_shattered_or_dead(shaman_3_sunit)
		end,
		0,
		function()
			bm:out("*** shaman_3_sunit is shattered or dead! ***")
			kill_count = kill_count + 1
			bm:set_objective("wh3_dlc25_qb_nur_tamurkhan_chieftain_beastman_objective_02", kill_count, 3)

			gb.sm:trigger_message("wave3_dead")
			ga_playerarmy:play_sound_charge()					--adds a charge/cheer sound effect when the unit dies
		end
	)
end

--release armies and make enemy charge player
ga_playerarmy:release_on_message("battle_started")

ga_enemy1:release_on_message("battle_started")
ga_enemy1:rush_on_message("battle_started")
ga_enemy1:attack_force_on_message("charge", ga_playerarmy)

ga_enemy2:release_on_message("battle_started")
ga_enemy2:rush_on_message("battle_started")
ga_enemy2:attack_force_on_message("charge", ga_playerarmy)

ga_enemy3:reinforce_on_message("wave3_reinforce");
ga_enemy3:release_on_message("wave3", 1000)
ga_enemy3:rush_on_message("wave3", 1000)
ga_enemy3:attack_force_on_message("wave3_charge", ga_playerarmy)

--routs almost dead waves or ones where the shaman is shattered/dead
ga_enemy1:message_on_casualties("wave1_dead", 0.8)
ga_enemy2:message_on_casualties("wave2_dead", 0.8)
ga_enemy3:message_on_casualties("wave3_dead", 0.8)

ga_enemy1:rout_over_time_on_message("wave1_dead", 90000)
ga_enemy2:rout_over_time_on_message("wave2_dead", 90000)
ga_enemy3:rout_over_time_on_message("wave3_dead", 90000)


gb:add_listener(
	"wave1_dead",
	function()
		if ga_enemy1.sunits:are_any_active_on_battlefield() == true then
			ga_enemy1.sunits:kill_proportion_over_time(1.0, 120000, false)
		end
	end
)
gb:add_listener(
	"wave2_dead",
	function()
		if ga_enemy2.sunits:are_any_active_on_battlefield() == true then
			ga_enemy2.sunits:kill_proportion_over_time(1.0, 120000, false)
		end
	end
)
gb:add_listener(
	"wave3_dead",
	function()
		if ga_enemy3.sunits:are_any_active_on_battlefield() == true then
			ga_enemy3.sunits:kill_proportion_over_time(1.0, 120000, false)
		end
	end
)

--lord must survive
gb:complete_objective_on_message("victory", "wh3_dlc25_qb_nur_tamurkhan_chieftain_survive_objective_01", 7000)

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------

--victory
gb:message_on_all_messages_received("victory", "wave1_dead", "wave2_dead", "wave3_dead")
gb:complete_objective_on_message("victory", "wh3_dlc25_qb_nur_tamurkhan_chieftain_beastman_objective_02", 8000)
ga_playerarmy:force_victory_on_message("victory", 12000)

--defeat
ga_playerarmy:message_on_commander_death("lord_dead", 1)
ga_playerarmy:message_on_casualties("lord_dead", 1)
ga_playerarmy:rout_over_time_on_message("lord_dead", 10000)
ga_enemy3:force_victory_on_message("lord_dead", 10000)
gb:fail_objective_on_message("lord_dead","wh3_dlc25_qb_nur_tamurkhan_chieftain_survive_objective_01")
gb:queue_help_on_message("lord_dead", "wh3_dlc25_qb_nur_tamurkhan_chieftain_death_hint_01", 8000, 2000, 1000, true)