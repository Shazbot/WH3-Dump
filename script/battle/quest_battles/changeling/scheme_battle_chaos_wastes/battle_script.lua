-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Changeling
-- Theatre Scheme - Chaos Wastes
-- Blighted Ravine – Realm of Nurgle
-- Attacker

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------

load_script_libraries();

gb = generated_battle:new(
	false,                                      		-- screen starts black
	false,                                      		-- prevent deployment for player
	true,                                    	  		-- prevent deployment for ai
	nil,  									          	-- intro cutscene function
	false                                      			-- debug mode
);

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player_01 = gb:get_army(gb:get_player_alliance_num());

ga_ai_kho = gb:get_army(gb:get_non_player_alliance_num(), "kho_enemy");
ga_ai_sla = gb:get_army(gb:get_non_player_alliance_num(), "sla_enemy");
ga_ai_nur = gb:get_army(gb:get_non_player_alliance_num(), "nur_enemy");
ga_ai_nur_boss = gb:get_army(gb:get_non_player_alliance_num(), "nur_boss");

-------------------------------------------------------------------------------------------------
---------------------------------------- REINFORCEMENTS -----------------------------------------
-------------------------------------------------------------------------------------------------

local reinforcements = bm:reinforcements();

nur_reinforce = bm:get_spawn_zone_collection_by_name("nur_reinforce");
nur_boss_reinforce = bm:get_spawn_zone_collection_by_name("nur_boss_reinforce");

ga_ai_nur:assign_to_spawn_zone_from_collection_on_message("start", nur_reinforce, false);
ga_ai_nur:message_on_number_deployed("nur_reinforce_deployed", true, 1);
ga_ai_nur:assign_to_spawn_zone_from_collection_on_message("nur_reinforce_deployed", nur_reinforce, false);

ga_ai_nur_boss:assign_to_spawn_zone_from_collection_on_message("start", nur_boss_reinforce, false);


for i = 1, reinforcements:attacker_reinforcement_lines_count() do
	
	local line = reinforcements:attacker_reinforcement_line(i);
	
	if (line:script_id() == "nur_reinforce") then
		line:enable_random_deployment_position();		
	end
end;

---------------
-----SETUP-----
---------------

gb:message_on_time_offset("start", 100);
gb:message_on_time_offset("hint_01", 1000);
gb:message_on_time_offset("objective_01", 5000);
gb:message_on_time_offset("objective_02", 10000);

-------------------------------------------------------------------------------------------------
------------------------------------------ALLY ORDERS--------------------------------------------
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
------------------------------------------ENEMY ORDERS-------------------------------------------
-------------------------------------------------------------------------------------------------

ga_ai_kho:rush_on_message("start");
ga_ai_kho:message_on_rout_proportion("kho_weak",0.6);
ga_ai_kho:message_on_rout_proportion("kho_dead",0.99);

ga_ai_sla:rush_on_message("start");
ga_ai_sla:message_on_rout_proportion("sla_weak",0.6);
ga_ai_sla:message_on_rout_proportion("sla_dead",0.99);

gb:message_on_all_messages_received("dae_weaker", "kho_weak", "sla_weak");

ga_ai_nur_boss:reinforce_on_message("dae_weaker");
ga_ai_nur_boss:message_on_any_deployed("nur_boss_in");
ga_ai_nur_boss:rush_on_message("nur_boss_in");
ga_ai_nur_boss:message_on_rout_proportion("nur_boss_dead",0.99);

ga_ai_nur:deploy_at_random_intervals_on_message(
	"dae_weaker", 				-- message
	1, 							-- min units
	1, 							-- max units
	20000, 						-- min period
	20000, 						-- max period
	"nur_boss_dead", 			-- cancel message
	nil,						-- spawn first wave immediately
	true,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

ga_ai_nur:message_on_any_deployed("nur_in");
ga_ai_nur:rush_on_message("nur_in");

gb:message_on_all_messages_received("dae_dead", "kho_dead", "sla_dead", "nur_boss_dead");

gb:add_listener(
	"nur_boss_dead",
	function()
		ga_ai_nur.sunits:kill_proportion_over_time(1.0, 5000, false);
	end,
	true
);

-------------------------------------------------------------------------------------------------
--------------------------------------- OBJECTIVES & HINTS --------------------------------------
-------------------------------------------------------------------------------------------------

gb:set_objective_with_leader_on_message("objective_01", "wh3_dlc24_tze_changeling_theatre_scheme_chaos_wastes_objective_01");
gb:complete_objective_on_message("kho_dead", "wh3_dlc24_tze_changeling_theatre_scheme_chaos_wastes_objective_01");

gb:set_objective_with_leader_on_message("objective_02", "wh3_dlc24_tze_changeling_theatre_scheme_chaos_wastes_objective_02");
gb:complete_objective_on_message("sla_dead", "wh3_dlc24_tze_changeling_theatre_scheme_chaos_wastes_objective_02");

gb:set_locatable_objective_callback_on_message(
    "nur_boss_in",
    "wh3_dlc24_tze_changeling_theatre_scheme_chaos_wastes_objective_03",
    0,
    function()
        local sunit = ga_ai_nur_boss.sunits:item(1);
        if sunit then
            local cam_targ = sunit.unit:position();
            local cam_pos = v_offset_by_bearing(
                cam_targ,
                get_bearing(cam_targ, bm:camera():position()),    -- horizontal bearing from camera target to current camera position
                75,                                                -- distance from camera position to camera target
                d_to_r(30)                                        -- vertical bearing from horizon to cam-targ/cam-pos line
            );
            return cam_pos, cam_targ;
        end;
    end,
    2
);

-- gb:set_objective_with_leader_on_message("nur_boss_in", "wh3_dlc24_tze_changeling_theatre_scheme_chaos_wastes_objective_03");
gb:complete_objective_on_message("nur_boss_dead", "wh3_dlc24_tze_changeling_theatre_scheme_chaos_wastes_objective_03");

gb:queue_help_on_message("hint_01", "wh3_dlc24_tze_changeling_theatre_scheme_chaos_wastes_hint_01");
gb:queue_help_on_message("dae_weaker", "wh3_dlc24_tze_changeling_theatre_scheme_chaos_wastes_hint_02");

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------

--ga_player_01:force_victory_on_message("nur_boss_dead", 7500);