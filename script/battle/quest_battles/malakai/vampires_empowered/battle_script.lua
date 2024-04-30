-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Malakai
-- Vampires Empowered
-- Land Battle - slaughter of the Grim
-- Attacker


-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------
load_script_libraries();


gb = generated_battle:new(
	false,                                      		-- screen starts black
	false,                                      		-- prevent deployment for player
	true,                                        		-- prevent deployment for ai
	function() end_deployment_phase() end,    			-- intro cutscene function
	false                                      			-- debug mode
);

gb:set_cutscene_during_deployment(true);

-------------------------------------------------------------------------------------------------
------------------------------------------ CUTSCENCE -------------------------------------------

function end_deployment_phase() 

	local gc = generated_cutscene:new(true);
	gc:add_element("Play_wh3_dlc25_dwf_malakai_undead_empowered_pt_01", "wh3_dlc25_dwf_malakai_undead_empowered_pt_01", "gc_slow_enemy_army_pan_front_right_to_front_left_far_high_01", 10000, true, false, false);
	gc:add_element("Play_wh3_dlc25_dwf_malakai_undead_empowered_pt_02", "wh3_dlc25_dwf_malakai_undead_empowered_pt_02", "gc_slow_enemy_army_pan_front_right_to_front_left_close_medium_01", 10000, true, false, false);
	gc:add_element("Play_wh3_dlc25_dwf_malakai_undead_empowered_pt_03", "wh3_dlc25_dwf_malakai_undead_empowered_pt_03", "gc_orbit_90_medium_commander_back_right_close_low_01", 7000, true, false, false);

	gb:start_generated_cutscene(gc) 

	teleport_battle_units()
	setup_necromancer_proximities_under_attack()
end
-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------
-- player
ga_player_01 = gb:get_army(gb:get_player_alliance_num(),1);

enemy_script_ids = {
	"necromancer_1",
	"necromancer_1_summons",
	"reinforcements",
	"enemy_vmp"
}

deployment_ids = {
	"necromancer_1",
	"necromancer_2"
}

spawn_flows = {
	{min_units = 1, max_units = 1, min_spawn_time = 5000, max_spawn_time = 30000} --- skeleton and zombies reinforcements from necromancers 
}

enemy_armies = {
	reinforcements = {army= gb:get_army(gb:get_non_player_alliance_num(), "reinforcements"), visible= false, spawn_zone = "reinforcements",winds=30},
	enemy_vmp = {army= gb:get_army(gb:get_non_player_alliance_num(), "enemy_vmp"), visible= true,  spawn_zone = nil, starts_enabled= false},
	necromancer_1 = {army= gb:get_army(gb:get_non_player_alliance_num(), "necromancer_1"), visible= true, proximity=125, starts_enabled= false, winds=30},
	necromancer_1_summons = {army= gb:get_army(gb:get_non_player_alliance_num(), "necromancer_1_summons"), visible= true, spawn_zone = "necromancer_1", winds=nil, cancel_message="necromancer_dead"}
}

-------------------------------------------------------------------------------------------------
------------------------------------------- ARMY PROPERTIES ------------------------------------------
-------------------------------------------------------------------------------------------------

for _, key in ipairs(enemy_script_ids) do
	local armies = enemy_armies[key]
	local army = enemy_armies[key].army
		if armies.winds == true then 
		for i = 1, army.sunits:count() do 
			army.sunits:item(i):modify_winds_of_magic_current(armies.winds, true)
		end
	end
	if armies.visible == true then 
		for i = 1, army.sunits:count() do 
			army.sunits:item(i):set_always_visible_no_leave_battle(true)
		end
	end
	 
end

local reinforcements = bm:reinforcements()
--- assign spawn zones
sz_collection_main = bm:get_spawn_zone_collection_by_name("necromancer_1", "necromancer_2")

--- change spawn zones randomly 
enemy_armies.necromancer_1_summons.army:assign_to_spawn_zone_from_collection_on_message("summons", sz_collection_main, false)
enemy_armies.necromancer_1_summons.army:message_on_number_deployed("enemies_deployed", true, 1)
enemy_armies.necromancer_1_summons.army:assign_to_spawn_zone_from_collection_on_message("enemies_deployed",sz_collection_main, false)


for i = 1, reinforcements:attacker_reinforcement_lines_count() do
	local line = reinforcements:attacker_reinforcement_line(i)
	for _, script_ids in ipairs(deployment_ids) do
		if (line:script_id() == script_ids) then
			line:enable_random_deployment_position()
			bm:out("position currently is " .. script_ids)
			break
		end
	end
end

-- vampire lord spawn zone
sz_vampire_lord_reinforcements = bm:get_spawn_zone_collection_by_name(enemy_armies.reinforcements.spawn_zone)
enemy_armies.reinforcements.army:assign_to_spawn_zone_from_collection_on_message("summons", sz_vampire_lord_reinforcements, false);

-------------------------------------------------------------------------------------------------
--------------------------------------------- TELEPORT ---------------------------------------------
-------------------------------------------------------------------------------------------------
function teleport_battle_units()
	bm:out("\tbattle_start_teleport_units() called")

	-- Necromancer 1 and units 
	enemy_armies.necromancer_1.army.sunits:item(1).uc:teleport_to_location(v(-441.17, 35), 37.24, 3.06)
	enemy_armies.necromancer_1.army.sunits:item(2).uc:teleport_to_location(v(-441.17, 35), 37.24, 40)
	enemy_armies.necromancer_1.army.sunits:item(3).uc:teleport_to_location(v(-416.72, 7.36), 37.24, 40)

end

-------------------------------------------------------------------------------------------------
-------------------------------------------- ENEMY ORDERS ---------------------------------------
-------------------------------------------------------------------------------------------------
gb:message_on_time_offset("start", 1500)
enemy_armies.enemy_vmp.army:message_on_casualties("summons", 0.4)
enemy_armies.enemy_vmp.army:message_on_casualties("deploy_vampire_lord", 0.85)
enemy_armies.enemy_vmp.army:rush_on_message("start")

--- Start reinforcements message
enemy_armies.necromancer_1_summons.army:rush_on_message("summons")

-------------------------------------------------------------------------------------------------
---------------------------------------- REINFORCEMENTS -----------------------------------------
-------------------------------------------------------------------------------------------------

function necromancer_deploy_summoned(army, flow, stop_message)
	army:deploy_at_random_intervals_on_message(
		"summons", -- message
		flow.min_units, -- min units
		flow.max_units, -- max units
		flow.min_spawn_time, -- min period
		flow.max_spawn_time, -- max period
		stop_message, -- cancel message
		nil, -- spawn first wave immediately
		true, -- allow respawning
		nil, -- survival battle wave index
		nil, -- is final survival wave
		false -- show debug output
	)
end

necromancer_deploy_summoned(enemy_armies.necromancer_1_summons.army, spawn_flows[1], enemy_armies.necromancer_1_summons.cancel_message)

enemy_armies.necromancer_1.army:message_on_commander_death("necromancer_dead")
enemy_armies.necromancer_1.army:add_ping_icon_on_message("summons")

enemy_armies.reinforcements.army:reinforce_on_message("deploy_vampire_lord")
enemy_armies.reinforcements.army:message_on_any_deployed("vampire_lord_deployed")
enemy_armies.reinforcements.army:add_ping_icon_on_message("vampire_lord_deployed")

-------------------------------------------------------------------------------------------------
------------------------------------------- GENERAL BEHAVIOURS ------------------------------------------
-------------------------------------------------------------------------------------------------

function setup_necromancer_proximities_under_attack()
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
			army:message_on_under_attack("summons")

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


-------------------------------------------------------------------------------------------------
--------------------------------------- CAMERA TARGETTING --------------------------------------
-------------------------------------------------------------------------------------------------

gb:set_locatable_objective_callback_on_message(
    "summons",
    "wh3_dlc25_dwf_malakai_vampires_empowered_02",
    0,
    function()
        local sunit = enemy_armies.necromancer_1.army.sunits:get_general_sunit();
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
    "necromancer_dead",
    "wh3_dlc25_dwf_malakai_vampires_empowered_04",
    0,
    function()
        local sunit = enemy_armies.reinforcements.army.sunits:get_sunit_by_type("wh2_dlc11_vmp_cha_bloodline_necrarch_lord_3");
		sunit:add_ping_icon()
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


-------------------------------------------------------------------------------------------------
--------------------------------------- GYROBOMER RELOAD --------------------------------------
-------------------------------------------------------------------------------------------------

local reload_vector = battle_vector:new(242 ,185 ,242); 
local reload_proximity_range = 50; 
--- Message on proximity to a battle vector 
ga_player_01:message_on_proximity_to_position("reload_bombs", reload_vector, 50)

gb:queue_help_on_message("start", "wh3_dlc25_dwf_malakai_vampires_empowered_reload_reminder", nil, nil, 45000)
gb:add_ping_icon_on_message("start", reload_vector, 8, 40000)

gb:add_listener(
    "reload_bombs",
	function()
		for i = 1, ga_player_01.sunits:count() do
			local sunit = ga_player_01.sunits:item(i);
			local unit = sunit.unit
			if unit:can_perform_special_ability("wh3_dlc25_unit_abilities_gyrobomber_fire_bomb") or unit:can_perform_special_ability("wh_main_unit_abilities_gyrobomber_bomb") or unit:can_perform_special_ability("wh_dlc06_unit_abilities_skyhammer_bomb") then
				if reload_vector:distance(unit:position()) < reload_proximity_range then
					sunit.uc:reset_ability_number_of_uses("wh3_dlc25_unit_abilities_gyrobomber_fire_bomb")
					sunit.uc:reset_ability_number_of_uses("wh_main_unit_abilities_gyrobomber_bomb")
					sunit.uc:reset_ability_number_of_uses("wh_dlc06_unit_abilities_skyhammer_bomb")
				end
			end
		end
	bm:callback(
		function()
			ga_player_01:message_on_proximity_to_position("reload_bombs", reload_vector, 50)
		end, 5000 
	)
	end,
	true
);


-------------------------------------------------------------------------------------------------
--------------------------------------- OBJECTIVES & HINTS --------------------------------------
-------------------------------------------------------------------------------------------------

--- kill starting army 
gb:set_objective_on_message("start", "wh3_dlc25_dwf_malakai_vampires_empowered_01");
gb:complete_objective_on_message("victory", "wh3_dlc25_dwf_malakai_vampires_empowered_01");


-- Kill Necromancer
gb:set_objective_on_message("summons", "wh3_dlc25_dwf_malakai_vampires_empowered_02", 5000);
gb:complete_objective_on_message("necromancer_dead", "wh3_dlc25_dwf_malakai_vampires_empowered_02");
gb:queue_help_on_message("summons", "wh3_dlc25_dwf_malakai_vampires_empowered_02_hint", 10000, nil, 3000);

-- necromancer dead 
enemy_armies.necromancer_1_summons.army:rout_over_time_on_message("necromancer_dead", 30000)
gb:complete_objective_on_message("necromancer_dead", "wh3_dlc25_dwf_malakai_vampires_empowered_05");

--- call vampire lord 
gb:set_objective_on_message("vampire_lord_deployed", "wh3_dlc25_dwf_malakai_vampires_empowered_04");
gb:queue_help_on_message("vampire_lord_deployed", "wh3_dlc25_dwf_malakai_vampires_empowered_03_hint", 8000, nil, 3000);

enemy_armies.necromancer_1.army:rout_over_time_on_message("necromancer_dead", 60000)
enemy_armies.necromancer_1.army:rout_over_time_on_message("victory", 45000)

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------

enemy_armies.reinforcements.army:message_on_commander_dead_or_shattered("victory")
gb:complete_objective_on_message("victory", "wh3_dlc25_dwf_malakai_vampires_empowered_04");
gb:queue_help_on_message("victory", "wh3_dlc25_dwf_malakai_vampires_empowered_04_hint", 8000, nil, 3000);
enemy_armies.reinforcements.army:rout_over_time_on_message("victory", 15000)
ga_player_01:force_victory_on_message("victory", 20000)
-------------------------------------------------------------------------------------------------
--------------------------------------------- DEFEAT --------------------------------------------
-------------------------------------------------------------------------------------------------

-- The player only loses if they get defeated.
ga_player_01:message_on_casualties("player_dead", 0.99)

gb:add_listener(
    "player_dead",
	function()
		bm:out("Player has died")

		bm:callback(
			function()
				-- end the battle after a short delay
				out.design("end battle")
				sm:trigger_message("end_battle_defeat")
			end,
			5000
		)
    end
)
enemy_armies.enemy_vmp.army:force_victory_on_message("end_battle_defeat", 3)