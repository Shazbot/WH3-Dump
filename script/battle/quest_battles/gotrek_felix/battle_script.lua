-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------
-- Gotrek and Felix Quest Battle
-- Gotrek and Felix Campaign Unlock
-- Geheimnisnacht Eve
-- Attacker
-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------
load_script_libraries()
bm = battle_manager:new(empire_battle:new());
gb =
	generated_battle:new(
	false, -- screen starts black
	true, -- prevent deployment for player
	true, -- prevent deployment for ai
	function() end_deployment_phase() end, -- intro cutscene function
	false -- debug mode
)
sm = script_messager:new()

gb:set_cutscene_during_deployment(true)

-----------------------------------------------------------------------------------------------
-------------------------------------- INTRO VO & SUBS ----------------------------------------
-----------------------------------------------------------------------------------------------
local sfx_cutscene_sweetener_play = new_sfx("Play_Movie_WH3_DLC25_QB_Gotrick_Felix_Nightmare_Of_Geheimnisacht_Sweetener")
local sfx_cutscene_sweetener_stop = new_sfx("Stop_Movie_WH3_DLC25_QB_Gotrick_Felix_Nightmare_Of_Geheimnisacht_Sweetener", false, false)

function end_deployment_phase()
	bm:out("\tend_deployment_phase() called")
		
	local cam = bm:camera()
	
	-- REMOVE ME
	cam:fade(true, 0)

	-- declare cutscene
	local cutscene_intro = cutscene:new_from_cindyscene(
		"cutscene_intro", 																-- unique string name for cutscene
		ga_attacker_01.sunits,															-- unitcontroller over player's army
		function() intro_cutscene_end() end,											-- what to call when cutscene is finished
		"script/battle/quest_battles/_cutscene/managers/nightmare_of_geheimnisnacht_eve_m01.CindySceneManager",			-- path to cindyscene
		0,																				-- blend in time (s)
		0																				-- blend out time (s)
	)
	
	local player_units_hidden = false
	
	-- set up subtitles
	local subtitles = cutscene_intro:subtitles()
	subtitles:set_alignment("bottom_centre")
	subtitles:clear()
	
	-- skip callback
	cutscene_intro:set_skippable(
		true, 
		function()
			local cam = bm:camera()
			cam:fade(true, 0)
			bm:stop_cindy_playback(true)
			
			if player_units_hidden then
				ga_attacker_01:set_enabled(false)
			end

			bm:callback(function() cam:fade(false, 0.5) end, 500)
			bm:hide_subtitles()
		end
	)
	
	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(false, 1) end, 1000)

	cutscene_intro:action(
		function()
			player_units_hidden = false
		end, 
		200
	)

	-- Voiceover and Subtitles --
	
	-- cutscene_intro:action(function() cutscene_intro:play_sound(wh3_dlc25_sfx_cutscene_sweetener_start) end, 100)


	cutscene_intro:action(function() cutscene_intro:play_sound(sfx_cutscene_sweetener_play) end, 350)

	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc25_qb_neu_gotrek_felix_pt_01", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc25_qb_neu_gotrek_felix_pt_01"))
				bm:show_subtitle("wh3_dlc25_neu_gotrek_felix_pt_01", false, true)
			end
	)

	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc25_qb_neu_gotrek_felix_pt_02", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc25_qb_neu_gotrek_felix_pt_02"))
				bm:show_subtitle("wh3_dlc25_neu_gotrek_felix_pt_02", false, true)
			end
	)

	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_dlc25_qb_neu_gotrek_felix_pt_03", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_dlc25_qb_neu_gotrek_felix_pt_03"))
				bm:show_subtitle("wh3_dlc25_neu_gotrek_felix_pt_03", false, true)
			end
	)

	cutscene_intro:start()
end

-----------------------------------------------------------------------------------------------
----------------------------------------- CUTSCENE --------------------------------------------
-----------------------------------------------------------------------------------------------

function intro_cutscene_end()
	play_sound_2D(sfx_cutscene_sweetener_stop)
	gb.sm:trigger_message("01_intro_cutscene_end")
	
end

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

-- player_army
ga_attacker_01 = gb:get_army(gb:get_player_alliance_num(),1)

-- Ally armies 
friendly_armies = {
	gotrek_felix = {army = gb:get_army(gb:get_player_alliance_num(), "gotrek_felix")}
}
gotrek = friendly_armies.gotrek_felix.army.sunits:item(1)
felix = friendly_armies.gotrek_felix.army.sunits:item(2)

-- enemy armies

enemy_script_ids = {
	"alluress_01",
	"alluress_02",
	"alluress_03",
	"dark_elves_reinforcements",
	"sla_mortal_reinforcements",
	"sla_daemons_reinforcements",
	"enemy_army"
	}
	
enemy_armies = {
	alluress_01 = {army= gb:get_army(gb:get_non_player_alliance_num(), "alluress_01"), visible= true, winds=30, proximity=125, death_message="alluress_01_dead"},
	alluress_02 = {army= gb:get_army(gb:get_non_player_alliance_num(), "alluress_02"), visible= true, winds=30, proximity=125, death_message="alluress_02_dead"},
	alluress_03 = {army= gb:get_army(gb:get_non_player_alliance_num(), "alluress_03"), visible= true, winds=30, proximity=125, death_message="alluress_03_dead"},
	dark_elves_reinforcements = {army= gb:get_army(gb:get_non_player_alliance_num(), "dark_elves_reinforcements"), visible= nil, deployment_ids = bm:get_spawn_zone_collection_by_name("dark_elves_portal"), message="dark_elves_reinforcements", cancel_message="alluress_01_dead"},
	sla_mortal_reinforcements = {army= gb:get_army(gb:get_non_player_alliance_num(), "sla_mortal_reinforcements"), visible= nil, deployment_ids = bm:get_spawn_zone_collection_by_name("sla_mortal_portal"),  message="sla_mortal_reinforcements", cancel_message="alluress_02_dead"},
	sla_daemons_reinforcements = {army= gb:get_army(gb:get_non_player_alliance_num(), "sla_daemons_reinforcements"),visible= nil,deployment_ids  =bm:get_spawn_zone_collection_by_name("sla_daemons_portal"), message="sla_daemons_reinforcements", cancel_message="alluress_03_dead"},
	enemy_army = {army= gb:get_army(gb:get_non_player_alliance_num(), "enemy_army"), unbreakable=false, visible= false, spawn_zone = nil, cancel_message="dark_elves_stop", winds=30}
}

-- reinforcement rate
spawn_flows = {
	{min_units = 1, max_units = 1, min_spawn_time = 10000, max_spawn_time = 30000} 
}

for _, key in ipairs(enemy_script_ids) do
	local armies = enemy_armies[key]
	local army = enemy_armies[key].army

	if armies.winds == true then 
		for i = 1, army.sunits:count() do 
			army.sunits:item(i):modify_winds_of_magic_reserve(armies.winds)
		end
	end
	if armies.visible == true or nil then
		for i = 1, army.sunits:count() do 
			army.sunits:item(i):set_always_visible_no_hidden_no_leave_battle(true)
		end 
	end
end

-------------------------------------------------------------------------------------------------
-----------------------------------------REINFORCEMENTS LINES -----------------------------------
-------------------------------------------------------------------------------------------------

function battle_start_teleport_units()
	bm:out("\tbattle_start_teleport_units() called")
	----------------------------------- ENEMY DEPLOYMENT SETUP -------------------------------------
		
	--- alluress 01 (players right side) DARK ELVES 
	enemy_armies.alluress_01.army.sunits:item(1).uc:teleport_to_location(v(113, -246), 180, 1.5)
	enemy_armies.alluress_01.army.sunits:item(2).uc:teleport_to_location(v(113, -246), 180, 30)

	--- alluress 02 and flankers (players left side) SLAANESH MORTALS
	enemy_armies.alluress_02.army.sunits:item(1).uc:teleport_to_location(v(89.50, 17.20), 24, 1.5)
	enemy_armies.alluress_02.army.sunits:item(2).uc:teleport_to_location(v(90.37, 15.05), 28, 30)
	
	-- alluress 03 (furthest from player) DAEMONS
	enemy_armies.alluress_03.army.sunits:item(1).uc:teleport_to_location(v(290, -150), 100, 1.5)
	enemy_armies.alluress_03.army.sunits:item(2).uc:teleport_to_location(v(265, -123), 134, 30)
	
	----------------------------------- ALLY DEPLOYMENT SETUP -------------------------------------

	-- Gotrek and Felix being teleported to position
	friendly_armies.gotrek_felix.army.sunits:item(1).uc:teleport_to_location(v(-170, -105), 90, 20)
	friendly_armies.gotrek_felix.army.sunits:item(2).uc:teleport_to_location(v(-170, -100), 90, 20)
	friendly_armies.gotrek_felix.army.sunits:item(1):set_invincible_for_time_proportion(0.4)
	friendly_armies.gotrek_felix.army.sunits:item(2):set_invincible_for_time_proportion(0.4)


end
battle_start_teleport_units()

-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-- ----------------------------------------------------------------------------------------------

gb:message_on_time_offset("reinforcements", 60000)
gb:message_on_time_offset("start", 2000)
gb:message_on_time_offset("alluresses", 15000)

enemy_armies.enemy_army.army:rush_on_message("start")
enemy_armies.enemy_army.army:message_on_under_attack("under_fire")
enemy_armies.enemy_army.army:attack_force_on_message("start", ga_attacker_01)
enemy_armies.enemy_army.army:rush_on_message("under_fire")

friendly_armies.gotrek_felix.army:message_on_proximity_to_ally("release", 75)
friendly_armies.gotrek_felix.army:message_on_proximity_to_enemy("release", 100)
friendly_armies.gotrek_felix.army:rush_on_message("release")

-------------------------------------------------------------------------------------------------
------------------------------------------- REINFORCEMENTS FLOW ---------------------------------
-------------------------------------------------------------------------------------------------

enemy_armies.dark_elves_reinforcements.army:assign_to_spawn_zone_from_collection_on_message("reinforcements", enemy_armies.dark_elves_reinforcements.deployment_ids, false)
enemy_armies.sla_mortal_reinforcements.army:assign_to_spawn_zone_from_collection_on_message("reinforcements", enemy_armies.sla_mortal_reinforcements.deployment_ids, false)
enemy_armies.sla_daemons_reinforcements.army:assign_to_spawn_zone_from_collection_on_message("reinforcements", enemy_armies.sla_daemons_reinforcements.deployment_ids, false)


function deploy_reinforcements(army, spawn_flow, cancel_message)
	army:deploy_at_random_intervals_on_message(
		"reinforcements", -- message
		spawn_flow.min_units, -- min units
		spawn_flow.max_units, -- max units
		spawn_flow.min_spawn_time, -- min period
		spawn_flow.max_spawn_time, -- max period
		cancel_message, -- cancel message
		nil, -- spawn first wave immediately
		true, -- allow respawning
		nil, -- survival battle wave index
		nil, -- is final survival wave
		false -- show debug output
	)
end

deploy_reinforcements(enemy_armies.dark_elves_reinforcements.army, spawn_flows[1], enemy_armies.dark_elves_reinforcements.cancel_message)
deploy_reinforcements(enemy_armies.sla_daemons_reinforcements.army, spawn_flows[1], enemy_armies.sla_daemons_reinforcements.cancel_message)
deploy_reinforcements(enemy_armies.sla_mortal_reinforcements.army, spawn_flows[1], enemy_armies.sla_mortal_reinforcements.cancel_message)

-- call enemy reinforcements
gb:queue_help_on_message("reinforcements", "wh3_dlc25_qb_gotrek_felix_unlock_hints_enemy_reinforcements")

-------------------------------------------------------------------------------------------------
------------------------------------------- GENERAL BEHAVIOURS ------------------------------------------
-------------------------------------------------------------------------------------------------

function setup_army_attack_proximities()
	-- Switch each army to attack once their individual proximity is breeched
	for _, key in ipairs(enemy_script_ids) do
		local armies = enemy_armies[key]
		local army = enemy_armies[key].army
		-- set proximity to nil if you never want the units to attack
		-- set proximity to 0 if you want them to attack from spawn
		if armies.proximity and armies.proximity > 0 then
			local proximity_key = key.."_proximity"
			local under_attack_key = key.."_under_attack"
			army:message_on_proximity_to_enemy(proximity_key, armies.proximity)
			army:message_on_under_attack(under_attack_key)

			gb:add_listener(
				proximity_key,
				function()
					army:attack()
				end
			)
			gb:add_listener(
				under_attack_key,
				function()
					army:attack()
				end
			)

		elseif(armies.proximity and armies.proximity == 0) then
			army:attack()
		end
	end
end
setup_army_attack_proximities()

-------------------------------------------------------------------------------------------------
--------------------------------------------- Gotrek and Felix check ----------------------------
-------------------------------------------------------------------------------------------------

-- felix is dead
if felix then
	bm:watch(
		function()
			return is_shattered_or_dead(felix)
		end,
		0,
		function()
			bm:out("*** Felix is shattered or dead ***")
			gb.sm:trigger_message("felix_dead")

		end
	)
end
-- gotrek is dead
if gotrek then
	bm:watch(
		function()
			return is_shattered_or_dead(gotrek)
		end,
		0,
		function()
			bm:out("*** Gotrek is shattered or dead ***")
			gb.sm:trigger_message("gotrek_dead")

		end
	)
end

-------------------------------------------------------------------------------------------------
--------------------------------------------- Alluress check ----------------------------
-------------------------------------------------------------------------------------------------

enemy_armies.alluress_01.army:message_on_commander_death(enemy_armies.alluress_01.death_message)
enemy_armies.alluress_02.army:message_on_commander_death(enemy_armies.alluress_02.death_message)
enemy_armies.alluress_03.army:message_on_commander_death(enemy_armies.alluress_03.death_message)

-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------
-- defend gotrek and felix objective, add ping icons to better show location.
gb:set_objective_on_message("start", "wh3_dlc25_qb_gotrek_felix_unlock_hints_objective_1")

friendly_armies.gotrek_felix.army:add_ping_icon_on_message("start", 15, 1)
friendly_armies.gotrek_felix.army:add_ping_icon_on_message("start", 15, 2)

---Kill Alluresses 
gb:set_objective_on_message("alluresses", "wh3_dlc25_qb_gotrek_felix_unlock_hints_objective_2", 5000)
gb:queue_help_on_message("alluresses", "wh3_dlc25_qb_gotrek_felix_unlock_hints_secondary_hint")

enemy_armies.alluress_01.army:add_ping_icon_on_message("alluresses", 5, 1)
enemy_armies.alluress_02.army:add_ping_icon_on_message("alluresses", 5, 1)
enemy_armies.alluress_03.army:add_ping_icon_on_message("alluresses", 5, 1)

gb:set_locatable_objective_callback_on_message(
    "alluresses",
    "wh3_dlc25_qb_gotrek_felix_unlock_hints_alluress_01",
    7000,
    function()
        local sunit = enemy_armies.alluress_01.army.sunits:item(1);
        if sunit then
            local cam_targ = sunit.unit:position();
            local cam_pos = v_offset_by_bearing(
                cam_targ,
                get_bearing(cam_targ, bm:camera():position()),    -- horizontal bearing from camera target to current camera position
                100,                                                -- distance from camera position to camera target
                d_to_r(30)                                        -- vertical bearing from horizon to cam-targ/cam-pos line
            );
            return cam_pos, cam_targ;
        end;
    end,
    2
);
gb:set_locatable_objective_callback_on_message(
    "alluresses",
    "wh3_dlc25_qb_gotrek_felix_unlock_hints_alluress_02",
    7000,
    function()
        local sunit = enemy_armies.alluress_02.army.sunits:item(1);
        if sunit then
            local cam_targ = sunit.unit:position();
            local cam_pos = v_offset_by_bearing(
                cam_targ,
                get_bearing(cam_targ, bm:camera():position()),    -- horizontal bearing from camera target to current camera position
                100,                                                -- distance from camera position to camera target
                d_to_r(30)                                        -- vertical bearing from horizon to cam-targ/cam-pos line
            );
            return cam_pos, cam_targ;
        end;
    end,
    2
);
gb:set_locatable_objective_callback_on_message(
    "alluresses",
    "wh3_dlc25_qb_gotrek_felix_unlock_hints_alluress_03",
    7000,
    function()
        local sunit = enemy_armies.alluress_03.army.sunits:item(1);
        if sunit then
            local cam_targ = sunit.unit:position();
            local cam_pos = v_offset_by_bearing(
                cam_targ,
                get_bearing(cam_targ, bm:camera():position()),    -- horizontal bearing from camera target to current camera position
                100,                                                -- distance from camera position to camera target
                d_to_r(30)                                        -- vertical bearing from horizon to cam-targ/cam-pos line
            );
            return cam_pos, cam_targ;
        end;
    end,
    2
);

gb:complete_objective_on_message(enemy_armies.alluress_01.death_message, "wh3_dlc25_qb_gotrek_felix_unlock_hints_alluress_01")
gb:complete_objective_on_message(enemy_armies.alluress_02.death_message, "wh3_dlc25_qb_gotrek_felix_unlock_hints_alluress_02")
gb:complete_objective_on_message(enemy_armies.alluress_03.death_message, "wh3_dlc25_qb_gotrek_felix_unlock_hints_alluress_03")


-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------


gb:complete_objective_on_message("victory", "wh3_dlc25_qb_gotrek_felix_unlock_hints_objective_2")
gb:message_on_all_messages_received("victory", enemy_armies.alluress_01.death_message, enemy_armies.alluress_02.death_message, enemy_armies.alluress_03.death_message)
ga_attacker_01:force_victory_on_message("victory", 7000)

-------------------------------------------------------------------------------------------------
--------------------------------------------- DEFEAT -------------------------------------------
-------------------------------------------------------------------------------------------------

gb:queue_help_on_message("gotrek_dead", "wh3_dlc25_neu_gotrek_felix_qb_gotrek_dead", 4000)
gb:queue_help_on_message("felix_dead", "wh3_dlc25_neu_gotrek_felix_qb_felix_dead", 4000)
gb:message_on_any_message_received("gotrek_or_felix_defeated","gotrek_dead","felix_dead")


gb:fail_objective_on_message("gotrek_or_felix_defeated", "wh3_dlc25_qb_gotrek_felix_unlock_hints_objective_1", 2000)
enemy_armies.enemy_army.army:force_victory_on_message("gotrek_or_felix_defeated", 30000)
