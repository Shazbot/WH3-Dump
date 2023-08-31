-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Changeling
-- Theatre Scheme - Ulthuan
-- Isle of the Dead
-- Defender

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------

load_script_libraries();

gb = generated_battle:new(
	false,                                      		-- screen starts black
	false,                                      		-- prevent deployment for player
	true,              	                        		-- prevent deployment for ai
	nil,  									          	-- intro cutscene function
	false                                      			-- debug mode
);

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player_01 = gb:get_army(gb:get_player_alliance_num());

ga_ai_ally_01 = gb:get_army(gb:get_player_alliance_num(), "caster_01");
ga_ai_ally_02 = gb:get_army(gb:get_player_alliance_num(), "caster_02");
ga_ai_ally_03 = gb:get_army(gb:get_player_alliance_num(), "caster_03");

ga_ai_ally_sla = gb:get_army(gb:get_player_alliance_num(), "slaanesh");

ga_ai_alarielle = gb:get_army(gb:get_non_player_alliance_num(), "alarielle");
ga_ai_alith_anar = gb:get_army(gb:get_non_player_alliance_num(), "alith_anar");
ga_ai_eltharion = gb:get_army(gb:get_non_player_alliance_num(), "eltharion");
ga_ai_imrik = gb:get_army(gb:get_non_player_alliance_num(), "imrik");
ga_ai_teclis = gb:get_army(gb:get_non_player_alliance_num(), "teclis");
ga_ai_tyrion = gb:get_army(gb:get_non_player_alliance_num(), "tyrion");

caster_01 = ga_ai_ally_01.sunits:item(1);
caster_02 = ga_ai_ally_02.sunits:item(1);
caster_03 = ga_ai_ally_03.sunits:item(1);

-------------------------------------------------------------------------------------------------
---------------------------------------- REINFORCEMENTS -----------------------------------------
-------------------------------------------------------------------------------------------------

local reinforcements = bm:reinforcements();

sla_reinforce = bm:get_spawn_zone_collection_by_name("sla_reinforce");

hef_reinforce_01 = bm:get_spawn_zone_collection_by_name("hef_reinforce_01");
hef_reinforce_02 = bm:get_spawn_zone_collection_by_name("hef_reinforce_02");
hef_reinforce_03 = bm:get_spawn_zone_collection_by_name("hef_reinforce_03");
hef_reinforce_04 = bm:get_spawn_zone_collection_by_name("hef_reinforce_04");
hef_reinforce_05 = bm:get_spawn_zone_collection_by_name("hef_reinforce_05");

reinforce_ally_01 = bm:get_spawn_zone_collection_by_name("ally_spawn_01");
reinforce_ally_02 = bm:get_spawn_zone_collection_by_name("ally_spawn_02");
reinforce_ally_03 = bm:get_spawn_zone_collection_by_name("ally_spawn_03");

ga_ai_ally_01:assign_to_spawn_zone_from_collection_on_message("start", reinforce_ally_01, false);
ga_ai_ally_02:assign_to_spawn_zone_from_collection_on_message("start", reinforce_ally_02, false);
ga_ai_ally_03:assign_to_spawn_zone_from_collection_on_message("start", reinforce_ally_03, false);

ga_ai_ally_sla:assign_to_spawn_zone_from_collection_on_message("start", sla_reinforce, false);
ga_ai_ally_sla:message_on_number_deployed("sla_reinforce_deployed", true, 1);
ga_ai_ally_sla:assign_to_spawn_zone_from_collection_on_message("sla_reinforce_deployed", sla_reinforce, false);

ga_ai_alith_anar:assign_to_spawn_zone_from_collection_on_message("start", hef_reinforce_01, false);
ga_ai_teclis:assign_to_spawn_zone_from_collection_on_message("start", hef_reinforce_02, false);
ga_ai_eltharion:assign_to_spawn_zone_from_collection_on_message("start", hef_reinforce_03, false);
ga_ai_alarielle:assign_to_spawn_zone_from_collection_on_message("start", hef_reinforce_04, false);
ga_ai_imrik:assign_to_spawn_zone_from_collection_on_message("start", hef_reinforce_05, false);

for i = 1, reinforcements:defender_reinforcement_lines_count() do
	
	local line = reinforcements:defender_reinforcement_line(i);
	
	if (line:script_id() == "sla_reinforce") then
		line:enable_random_deployment_position();		
	end
end;

---------------
-----SETUP-----
---------------

gb:message_on_time_offset("start", 100);
gb:message_on_time_offset("hint_01", 1000);
gb:message_on_time_offset("objective_01", 5000);

gb:message_on_time_offset("hero_01", 2000);
gb:message_on_time_offset("hero_02", 3000);
gb:message_on_time_offset("hero_03", 4000);

-------------------------------------------------------------------------------------------------
------------------------------------------ALLY ORDERS--------------------------------------------
-------------------------------------------------------------------------------------------------

gb:add_listener(
	"hero_01",
	function()
		caster_01:add_ping_icon(15);
	end
);

gb:add_listener(
	"hero_02",
	function()
		caster_02:add_ping_icon(15);
	end
);

gb:add_listener(
	"hero_03",
	function()
		caster_03:add_ping_icon(15);
	end
);

ga_player_01:message_on_commander_death("changeling_dead");

ga_ai_ally_01:reinforce_on_message("start")
ga_ai_ally_01:message_on_deployed("tze_ally_01_in");
ga_ai_ally_01:attack_on_message("tze_ally_01_in");
ga_ai_ally_01:message_on_rout_proportion("caster_01_dead",0.99);

ga_ai_ally_02:reinforce_on_message("start")
ga_ai_ally_02:message_on_deployed("tze_ally_02_in");
ga_ai_ally_02:attack_on_message("tze_ally_02_in");
ga_ai_ally_02:message_on_rout_proportion("caster_02_dead",0.99);

ga_ai_ally_03:reinforce_on_message("start")
ga_ai_ally_03:message_on_deployed("tze_ally_03_in");
ga_ai_ally_03:attack_on_message("tze_ally_03_in");
ga_ai_ally_03:message_on_rout_proportion("caster_03_dead",0.99);

gb:message_on_all_messages_received("casters_deployed", "tze_ally_01_in", "tze_ally_02_in", "tze_ally_03_in");
gb:message_on_all_messages_received("casters_dead", "caster_01_dead", "caster_02_dead", "caster_03_dead");

gb:message_on_time_offset("casters_ready", 7500, "casters_deployed");

ga_ai_ally_sla:message_on_any_deployed("sla_ally_in");
ga_ai_ally_sla:rush_on_message("sla_ally_in");

-------------------------------------------------------------------------------------------------
------------------------------------------ENEMY ORDERS-------------------------------------------
-------------------------------------------------------------------------------------------------

ga_ai_alarielle = gb:get_army(gb:get_non_player_alliance_num(), "alarielle");
ga_ai_alith_anar = gb:get_army(gb:get_non_player_alliance_num(), "alith_anar");
ga_ai_eltharion = gb:get_army(gb:get_non_player_alliance_num(), "eltharion");
ga_ai_imrik = gb:get_army(gb:get_non_player_alliance_num(), "imrik");
ga_ai_teclis = gb:get_army(gb:get_non_player_alliance_num(), "teclis");
ga_ai_tyrion = gb:get_army(gb:get_non_player_alliance_num(), "tyrion");

ga_ai_tyrion:attack_on_message("hint_01");
ga_ai_tyrion:message_on_rout_proportion("tyrion_threshold_01",0.15);
ga_ai_tyrion:message_on_rout_proportion("tyrion_threshold_02",0.3);
ga_ai_tyrion:message_on_rout_proportion("tyrion_threshold_03",0.45);
ga_ai_tyrion:message_on_rout_proportion("tyrion_threshold_04",0.6);
ga_ai_tyrion:message_on_rout_proportion("tyrion_threshold_05",0.75);
ga_ai_tyrion:message_on_rout_proportion("tyrion_dead",0.99);

ga_ai_teclis:reinforce_on_message("tyrion_threshold_01");
ga_ai_teclis:message_on_any_deployed("teclis_in");
ga_ai_teclis:attack_on_message("teclis_in");
ga_ai_teclis:message_on_rout_proportion("teclis_dead",0.99);

ga_ai_imrik:reinforce_on_message("tyrion_threshold_02");
ga_ai_imrik:message_on_any_deployed("imrik_in");
ga_ai_imrik:attack_on_message("imrik_in");
ga_ai_imrik:message_on_rout_proportion("imrik_dead",0.99);

ga_ai_eltharion:reinforce_on_message("tyrion_threshold_03");
ga_ai_eltharion:message_on_any_deployed("eltharion_in");
ga_ai_eltharion:attack_on_message("eltharion_in");
ga_ai_eltharion:message_on_rout_proportion("eltharion_dead",0.99);

ga_ai_alith_anar:reinforce_on_message("tyrion_threshold_04");
ga_ai_alith_anar:message_on_any_deployed("alith_anar_in");
ga_ai_alith_anar:attack_on_message("alith_anar_in");
ga_ai_alith_anar:message_on_rout_proportion("alith_anar_dead",0.99);

ga_ai_alarielle:reinforce_on_message("tyrion_threshold_05");
ga_ai_alarielle:message_on_any_deployed("alarielle_in");
ga_ai_alarielle:attack_on_message("alarielle_in");
ga_ai_alarielle:message_on_rout_proportion("alarielle_dead",0.99);

gb:message_on_all_messages_received("hef_dead", "tyrion_dead", "teclis_dead", "imrik_dead", "eltharion_dead", "alith_anar_dead", "alarielle_dead");

-------------------------------------------------------------------------------------------------
--------------------------------------- OBJECTIVES & HINTS --------------------------------------
-------------------------------------------------------------------------------------------------

gb:set_objective_with_leader_on_message("objective_01", "wh3_dlc24_tze_changeling_theatre_scheme_ulthuan_objective_02");
gb:complete_objective_on_message("hef_dead", "wh3_dlc24_tze_changeling_theatre_scheme_ulthuan_objective_02");

gb:queue_help_on_message("hint_01", "wh3_dlc24_tze_changeling_theatre_scheme_ulthuan_hint_tyrion");

gb:queue_help_on_message("alarielle_in", "wh3_dlc24_tze_changeling_theatre_scheme_ulthuan_hint_alarielle");
gb:queue_help_on_message("alith_anar_in", "wh3_dlc24_tze_changeling_theatre_scheme_ulthuan_hint_alith_anar");
gb:queue_help_on_message("eltharion_in", "wh3_dlc24_tze_changeling_theatre_scheme_ulthuan_hint_eltharion");
gb:queue_help_on_message("imrik_in", "wh3_dlc24_tze_changeling_theatre_scheme_ulthuan_hint_imrik");
gb:queue_help_on_message("teclis_in", "wh3_dlc24_tze_changeling_theatre_scheme_ulthuan_hint_teclis");

gb:queue_help_on_message("casters_ready", "wh3_dlc24_tze_changeling_theatre_scheme_ulthuan_hint_casters_in");
gb:queue_help_on_message("casters_dead", "wh3_dlc24_tze_changeling_theatre_scheme_ulthuan_hint_casters_dead");

gb:queue_help_on_message("sla_ally_in", "wh3_dlc24_tze_changeling_theatre_scheme_ulthuan_hint_slaanesh");

final_obj_time = 2000
update_value = 8

gb:add_listener(
    "caster_01_dead",
	function()
		update_value = update_value -2
    end,
	true
)

gb:add_listener(
    "caster_02_dead",
	function()
		update_value = update_value -2
    end,
	true
)

gb:add_listener(
    "caster_03_dead",
	function()
		update_value = update_value -2
    end,
	true
)

gb:add_listener(
    "changeling_dead",
	function()
		update_value = update_value -1
    end,
	true
)

gb:add_listener(
    "casters_deployed",
	function()
		bm:set_objective("wh3_dlc24_tze_changeling_theatre_scheme_ulthuan_objective_01", final_obj_time)

		bm:repeat_callback(
			function()
				final_obj_time = final_obj_time - update_value

				if final_obj_time <= 0 then
					sm:trigger_message("help_04");

					bm:complete_objective("wh3_dlc24_tze_changeling_theatre_scheme_ulthuan_objective_01");
					bm:remove_callback("end_countdown");

					ga_ai_ally_sla.sunits:deploy_at_random_intervals(
						1, 							-- min units
						1, 							-- max units
						5000, 						-- min period
						5000, 						-- max period
						false,						-- show debug output
						true,						-- spawn immediately
						false,						-- allow respawning 
						nil							-- new wave callback
					);
				else
					bm:set_objective("wh3_dlc24_tze_changeling_theatre_scheme_ulthuan_objective_01", final_obj_time);
				end
			end, 
			1000,
			"end_countdown"
		)
	end
)

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

gb:block_message_on_message("player_army_dead", "casters_dead", true);

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player_01:message_on_rout_proportion("player_army_dead", 1.0);

-- ga_player_01:force_victory_on_message("hef_dead", 5000);
ga_ai_tyrion:force_victory_on_message("player_army_dead", 5000);