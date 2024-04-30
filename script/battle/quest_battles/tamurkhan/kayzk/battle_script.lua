-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Tamurkhan (kayzk chieftain devoted battle)
-- Fatsod the Devourer
-- wh3_main_macro_nur_wastes_01
-- Attacker

load_script_libraries()


gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	true,                                     	-- prevent deployment for ai
	function() play_intro_cutscene() end,      	-- intro cutscene function -- nil, --
	false                                      	-- debug mode
)

wh3_intro_sfx_01 = new_sfx("Play_wh3_dlc25_qb_nur_tamurkhan_chieftain_kazyk")
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
	ga_enemy_casters.sunits:set_always_visible(true)
	ga_enemy_guards.sunits:set_always_visible(true)

	local cutscene_intro = cutscene:new_from_cindyscene(
        -- unique string name for cutscene
        "cutscene_intro",
        -- unitcontroller or scriptunits collection over player's army
        ga_playerarmy.sunits,
        -- end callback
        function() intro_cutscene_end() end,
        -- path to cindy scene
        "script\\battle\\quest_battles\\_cutscene\\managers\\fatsod_the_devourer_m01.CindySceneManager",
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
		"Play_wh3_dlc25_qb_nur_tamurkhan_chieftain_kazyk", 
			function()
				cutscene_intro:play_sound(wh3_intro_sfx_01)
				bm:show_subtitle("wh3_dlc25_qb_nur_tamurkhan_chieftain_kazyk", false, true)
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
ga_enemy1 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_1")
ga_enemy2 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_2")
ga_enemy_casters = gb:get_army(gb:get_non_player_alliance_num(), "casters")
ga_enemy_guards = gb:get_army(gb:get_non_player_alliance_num(), "guards")

--defining bosses in script
fatsod = ga_enemy1.sunits:get_sunit_by_type("wh3_dlc25_nur_cha_exalted_great_unclean_one_nurgle_qb_boss")


-------------------------------------------------------------------------------------------------
----------------------------------------- ARMY TELEPORT -----------------------------------------
-------------------------------------------------------------------------------------------------

-- casters
ga_enemy_casters.sunits:item(1).uc:teleport_to_location(v(295, -277), 229, 2)
ga_enemy_casters.sunits:item(2).uc:teleport_to_location(v(194, -250), 143, 2)
ga_enemy_casters.sunits:item(3).uc:teleport_to_location(v(222, -376), 17, 2)


-- guards
ga_enemy_guards.sunits:item(1).uc:teleport_to_location(v(312, -263), 57, 39)
ga_enemy_guards.sunits:item(2).uc:teleport_to_location(v(186, -230), 338, 39)
ga_enemy_guards.sunits:item(3).uc:teleport_to_location(v(217, -393), 194, 39)


-------------------------------------------------------------------------------------------------
---------------------------------- ORDERS & OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------



for i = 1, ga_enemy_casters.sunits:count() do
	local sunit = ga_enemy_casters.sunits:item(i)
	sunit:add_ping_icon(15)
	sunit:take_control()
	sunit:set_stat_attribute("unbreakable", true)
end

for i = 1, ga_enemy_guards.sunits:count() do
	local sunit = ga_enemy_guards.sunits:item(i)
	sunit:take_control()
end

--boss functions
gb:add_listener("battle_started", function() 
	bm:set_objective("wh3_dlc25_qb_nur_tamurkhan_chieftain_kazyk_objective_03")
	bm:set_objective("wh3_dlc25_qb_nur_tamurkhan_chieftain_survive_objective_01")
	bm:queue_help_message("wh3_dlc25_qb_nur_tamurkhan_chieftain_kazyk_hint_02", 8000, 2000, true)

	sap_1 = script_ai_planner:new("sap_1", ga_enemy_guards.sunits:item(1))
	sap_2 = script_ai_planner:new("sap_2", ga_enemy_guards.sunits:item(2))
	sap_3 = script_ai_planner:new("sap_3", ga_enemy_guards.sunits:item(3))

	sap_1:defend_position(v(312, -263), 20)
	sap_2:defend_position(v(186, -230), 20)
	sap_3:defend_position(v(217, -393), 20)

	fatsod:set_invincible(true)

	for i = 1, ga_enemy_casters.sunits:count() do
		local sunit = ga_enemy_casters.sunits:item(i)

		out.design(tostring(sunit))

		if sunit.unit:can_perform_special_ability("wh3_dlc20_quest_passive_daemonblade_mages") then
			out.design(tostring("has ability"))
			sunit.uc:perform_special_ability("wh3_dlc20_quest_passive_daemonblade_mages", sunit.unit)
		end
	end
end)


--boss killed function
if fatsod then
	bm:watch(
		function()
			return is_shattered_or_dead(fatsod)
		end,
		0,
		function()
			bm:out("*** fatsod is shattered or dead! ***")
			gb.sm:trigger_message("victory")
			ga_playerarmy:play_sound_charge()	--adds a charge/cheer sound effect when the unit dies
			bm:queue_help_message("wh3_dlc25_qb_nur_tamurkhan_chieftain_kazyk_hint_05", 8000, 2000, true)
		end
	)
end

--release armies and make enemy charge player
gb:message_on_time_offset("battle_started", 3000)

ga_enemy1:rush_on_message("battle_started", 1000)
ga_enemy1:message_on_casualties("hint", 0.1)

-- casters
ga_enemy_casters:message_on_casualties("casters_dead", 0.99)

gb:complete_objective_on_message("casters_dead", "wh3_dlc25_qb_nur_tamurkhan_chieftain_kazyk_objective_03")
gb:set_objective_on_message("casters_dead", "wh3_dlc25_qb_nur_tamurkhan_chieftain_kazyk_objective_02", 3000)
gb:remove_objective_on_message("casters_dead", "wh3_dlc25_qb_nur_tamurkhan_chieftain_kazyk_objective_03", 5000)

gb:add_listener("casters_dead", function() 
	fatsod:set_invincible(false)
	sap_1:release()
	sap_2:release()
	sap_3:release()
end)

ga_enemy2:reinforce_on_message("casters_dead")


--lord must survive
gb:complete_objective_on_message("victory", "wh3_dlc25_qb_nur_tamurkhan_chieftain_survive_objective_01", 1000)
gb:complete_objective_on_message("victory", "wh3_dlc25_qb_nur_tamurkhan_chieftain_kazyk_objective_02", 1000)

--hints
gb:queue_help_on_message("casters_dead", "wh3_dlc25_qb_nur_tamurkhan_chieftain_kazyk_hint_01", 8000, 2000)
gb:queue_help_on_message("casters_dead", "wh3_dlc25_qb_nur_tamurkhan_chieftain_kazyk_hint_03", 8000, 2000)

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------

--victory
ga_playerarmy:force_victory_on_message("victory", 1000)

--defeat
ga_playerarmy:message_on_commander_death("lord_dead", 1)
ga_playerarmy:message_on_casualties("lord_dead", 1)
ga_playerarmy:rout_over_time_on_message("lord_dead", 10000)
ga_enemy1:force_victory_on_message("lord_dead", 10000)
gb:queue_help_on_message("lord_dead", "wh3_dlc25_qb_nur_tamurkhan_chieftain_death_hint_01", 8000, 2000, 1000, true)
gb:fail_objective_on_message("lord_dead", "wh3_dlc25_qb_nur_tamurkhan_chieftain_survive_objective_01")
