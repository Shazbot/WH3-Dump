-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Changeling
-- Ultimate Scheme IE
-- Devestation at Ostermark
-- Defender

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------

load_script_libraries();
bm = battle_manager:new(empire_battle:new());

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

ga_ai_ally_01 = gb:get_army(gb:get_player_alliance_num(), "caster_01");
ga_ai_ally_02 = gb:get_army(gb:get_player_alliance_num(), "caster_02");
ga_ai_ally_03 = gb:get_army(gb:get_player_alliance_num(), "caster_03");

ga_ally_cst_reinforce = gb:get_army(gb:get_player_alliance_num(), "cst_ally");
ga_ally_grn_reinforce = gb:get_army(gb:get_player_alliance_num(), "grn_ally");
ga_ally_nor_reinforce = gb:get_army(gb:get_player_alliance_num(), "nor_ally");
ga_ally_skv_reinforce = gb:get_army(gb:get_player_alliance_num(), "skv_ally");
ga_ally_tmb_reinforce = gb:get_army(gb:get_player_alliance_num(), "tmb_ally");

ga_ai_start_emp = gb:get_army(gb:get_non_player_alliance_num(), "emp_start_enemy");
ga_ai_start_dwf_reinforce = gb:get_army(gb:get_non_player_alliance_num(), "dwf_start_enemy");
ga_ai_start_ksl_reinforce = gb:get_army(gb:get_non_player_alliance_num(), "ksl_start_enemy");

ga_ai_emp_reinforce = gb:get_army(gb:get_non_player_alliance_num(), "emp_enemy");
ga_ai_brt_reinforce = gb:get_army(gb:get_non_player_alliance_num(), "brt_enemy");
ga_ai_cth_reinforce = gb:get_army(gb:get_non_player_alliance_num(), "cth_enemy");
ga_ai_hef_reinforce = gb:get_army(gb:get_non_player_alliance_num(), "hef_enemy");

-------------------------------------------------------------------------------------------------
---------------------------------------- REINFORCEMENTS -----------------------------------------
-------------------------------------------------------------------------------------------------

local reinforcements = bm:reinforcements();

reinforce_ally_01 = bm:get_spawn_zone_collection_by_name("ally_spawn_01");
reinforce_ally_02 = bm:get_spawn_zone_collection_by_name("ally_spawn_02");
reinforce_ally_03 = bm:get_spawn_zone_collection_by_name("ally_spawn_03");

ga_ai_ally_01:assign_to_spawn_zone_from_collection_on_message("start", reinforce_ally_01, false);
ga_ai_ally_02:assign_to_spawn_zone_from_collection_on_message("start", reinforce_ally_02, false);
ga_ai_ally_03:assign_to_spawn_zone_from_collection_on_message("start", reinforce_ally_03, false);

dwf_start_reinforce = bm:get_spawn_zone_collection_by_name("brt_reinforcement", "hef_reinforcement");
ksl_start_reinforce = bm:get_spawn_zone_collection_by_name("emp_reinforcement", "cth_reinforcement");

ga_ai_start_dwf_reinforce:assign_to_spawn_zone_from_collection_on_message("start", dwf_start_reinforce, false);
ga_ai_start_dwf_reinforce:message_on_number_deployed("dwf_start_deployed", true, 1);
ga_ai_start_dwf_reinforce:assign_to_spawn_zone_from_collection_on_message("dwf_start_deployed", dwf_start_reinforce, false);

ga_ai_start_ksl_reinforce:assign_to_spawn_zone_from_collection_on_message("start", ksl_start_reinforce, false);
ga_ai_start_ksl_reinforce:message_on_number_deployed("ksl_start_deployed", true, 1);
ga_ai_start_ksl_reinforce:assign_to_spawn_zone_from_collection_on_message("ksl_start_deployed", ksl_start_reinforce, false);

emp_reinforce = bm:get_spawn_zone_collection_by_name("emp_reinforcement");
brt_reinforce = bm:get_spawn_zone_collection_by_name("brt_reinforcement");
cth_reinforce = bm:get_spawn_zone_collection_by_name("cth_reinforcement");
hef_reinforce = bm:get_spawn_zone_collection_by_name("hef_reinforcement");

ga_ai_emp_reinforce:assign_to_spawn_zone_from_collection_on_message("campaign_reinforcements", emp_reinforce, false);
ga_ai_brt_reinforce:assign_to_spawn_zone_from_collection_on_message("campaign_reinforcements", brt_reinforce, false);
ga_ai_cth_reinforce:assign_to_spawn_zone_from_collection_on_message("campaign_reinforcements", cth_reinforce, false);
ga_ai_hef_reinforce:assign_to_spawn_zone_from_collection_on_message("campaign_reinforcements", hef_reinforce, false);

cst_reinforce = bm:get_spawn_zone_collection_by_name("cst_reinforcement");
grn_reinforce = bm:get_spawn_zone_collection_by_name("grn_reinforcement");
nor_reinforce = bm:get_spawn_zone_collection_by_name("nor_reinforcement");
skv_reinforce = bm:get_spawn_zone_collection_by_name("skv_reinforcement");
tmb_reinforce = bm:get_spawn_zone_collection_by_name("tmb_reinforcement");
tze_reinforce = bm:get_spawn_zone_collection_by_name("tze_reinforcement");

ga_ally_cst_reinforce:assign_to_spawn_zone_from_collection_on_message("campaign_reinforcements", cst_reinforce, false);
ga_ally_cst_reinforce:message_on_number_deployed("bloater_deployed", true, 1);
ga_ally_cst_reinforce:assign_to_spawn_zone_from_collection_on_message("bloater_deployed", cst_reinforce, false);

ga_ally_grn_reinforce:assign_to_spawn_zone_from_collection_on_message("campaign_reinforcements", grn_reinforce, false);

ga_ally_nor_reinforce:assign_to_spawn_zone_from_collection_on_message("campaign_reinforcements", nor_reinforce, false);
ga_ally_nor_reinforce:message_on_number_deployed("norscan_deployed", true, 1);
ga_ally_nor_reinforce:assign_to_spawn_zone_from_collection_on_message("norscan_deployed", nor_reinforce, false);

ga_ally_skv_reinforce:assign_to_spawn_zone_from_collection_on_message("campaign_reinforcements", skv_reinforce, false);

ga_ally_tmb_reinforce:assign_to_spawn_zone_from_collection_on_message("campaign_reinforcements", tmb_reinforce, false);

for i = 1, reinforcements:defender_reinforcement_lines_count() do
	
	local line = reinforcements:defender_reinforcement_line(i);
	
	if (line:script_id() == "cst_reinforcement") then
		line:enable_random_deployment_position();		
	end

	if (line:script_id() == "nor_reinforcement") then
		line:enable_random_deployment_position();		
	end

	if (line:script_id() == "tze_reinforcement") then
		line:enable_random_deployment_position();		
	end
end;

---------------
-----SETUP-----
---------------

gb:message_on_time_offset("start", 100);
gb:message_on_time_offset("campaign_reinforcements", 1000);
gb:message_on_time_offset("objective_01", 7000);
gb:message_on_time_offset("objective_02", 12000);

-------------------------------------------------------------------------------------------------
------------------------------------------ALLY ORDERS--------------------------------------------
-------------------------------------------------------------------------------------------------

ga_ai_ally_01:reinforce_on_message("objective_01")
ga_ai_ally_01:message_on_deployed("tze_ally_01_in");
ga_ai_ally_01:defend_on_message("tze_ally_01_in", 135, 160, 25); 
ga_ai_ally_01:message_on_rout_proportion("caster_01_dead",0.99);

ga_ai_ally_02:reinforce_on_message("objective_01")
ga_ai_ally_02:message_on_deployed("tze_ally_02_in");
ga_ai_ally_02:defend_on_message("tze_ally_02_in", 135, 160, 25); 
ga_ai_ally_02:message_on_rout_proportion("caster_02_dead",0.99);

ga_ai_ally_03:reinforce_on_message("objective_01")
ga_ai_ally_03:message_on_deployed("tze_ally_03_in");
ga_ai_ally_03:defend_on_message("tze_ally_03_in", 135, 160, 25);
ga_ai_ally_03:message_on_rout_proportion("caster_03_dead",0.99);

gb:message_on_all_messages_received("all_casters_dead", "caster_01_dead", "caster_02_dead", "caster_03_dead");

-------------------------------------------------------------------------------------------------
------------------------------------------ENEMY ORDERS-------------------------------------------
-------------------------------------------------------------------------------------------------

ga_ai_start_emp:attack_on_message("start");
ga_ai_start_emp:message_on_rout_proportion("emp_start_dead",0.99);

ga_ai_start_dwf_reinforce:deploy_at_random_intervals_on_message(
	"start",				 	-- message
	1, 							-- min units
	1, 							-- max units
	30000, 						-- min period
	30000, 						-- max period
	nil,				 		-- cancel message
	nil,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);


ga_ai_start_dwf_reinforce:message_on_any_deployed("dwf_reinforce_in");
ga_ai_start_dwf_reinforce:rush_on_message("dwf_reinforce_in");

ga_ai_start_ksl_reinforce:deploy_at_random_intervals_on_message(
	"start",	 				-- message
	1, 							-- min units
	1, 							-- max units
	30000, 						-- min period
	30000, 						-- max period
	nil,				 		-- cancel message
	nil,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);


ga_ai_start_ksl_reinforce:message_on_any_deployed("ksl_reinforce_in");
ga_ai_start_ksl_reinforce:rush_on_message("ksl_reinforce_in");

-------------------------------------------------------------------------------------------------
--------------------------------------- OBJECTIVES & HINTS --------------------------------------
-------------------------------------------------------------------------------------------------


final_obj_time = 4000
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
    "objective_02",
	function()
		bm:set_objective("wh3_dlc24_tze_changeling_theatre_scheme_ultimate_objective_01", final_obj_time)

		bm:repeat_callback(
			function()
				final_obj_time = final_obj_time - update_value

				if final_obj_time <= 3900 then
					sm:trigger_message("call_emp_reinforce");
				end

				if final_obj_time <= 3600 then
					sm:trigger_message("call_brt_reinforce");
				end

				if final_obj_time <= 3300 then
					sm:trigger_message("call_tmb_reinforce");
				end

				if final_obj_time <= 3000 then
					sm:trigger_message("call_grn_reinforce");
				end

				if final_obj_time <= 2700 then
					sm:trigger_message("call_nor_reinforce");
				end

				if final_obj_time <= 2400 then
					sm:trigger_message("call_cst_reinforce");
				end

				if final_obj_time <= 2100 then
					sm:trigger_message("call_cth_reinforce");
				end

				if final_obj_time <= 1800 then
					sm:trigger_message("call_skv_reinforce");
				end

				if final_obj_time <= 1500 then
					sm:trigger_message("call_hef_reinforce");
				end

				if final_obj_time < 0 then
					sm:trigger_message("ritual_completed");
					bm:complete_objective("wh3_dlc24_tze_changeling_theatre_scheme_ultimate_objective_01");
					bm:remove_callback("end_countdown");
				else
					bm:set_objective("wh3_dlc24_tze_changeling_theatre_scheme_ultimate_objective_01", final_obj_time);
				end
			end, 
			1000,
			"end_countdown"
		)
	end
);

gb:complete_objective_on_message("ritual_completed", "wh3_dlc24_tze_changeling_theatre_scheme_ultimate_objective_01");
gb:fail_objective_on_message("all_casters_dead", "wh3_dlc24_tze_changeling_theatre_scheme_empire_objective_01")

gb:set_objective_with_leader_on_message("objective_02", "wh3_dlc24_tze_changeling_theatre_scheme_ultimate_objective_02");
gb:complete_objective_on_message("ritual_completed", "wh3_dlc24_tze_changeling_theatre_scheme_ultimate_objective_02");
gb:fail_objective_on_message("changeling_dead", "wh3_dlc24_tze_changeling_theatre_scheme_empire_objective_01")

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

------------------------------
-----CAMPAIGN ALLY EMPIRE-----
------------------------------

local ultimate_scheme_empire = tonumber(core:svr_load_string("the_changeling_empire_army_reinforce"))
 
function spawn_empire_campaign_army()
	if ultimate_scheme_empire == 1 then
		gb:message_on_time_offset("emp_reinforce_defeated", 100);
		bm:out("Not adding Empire units");
	elseif ultimate_scheme_empire == 0 then
		ga_ai_emp_reinforce:reinforce_on_message("call_emp_reinforce");
		ga_ai_emp_reinforce:get_army():suppress_reinforcement_adc(1);

		ga_ai_emp_reinforce:message_on_any_deployed("emp_reinforce_in");
		ga_ai_emp_reinforce:rush_on_message("emp_reinforce_in");
		gb:queue_help_on_message("emp_reinforce_in", "wh3_dlc24_tze_changeling_theatre_scheme_ultimate_hint_emp");

		ga_ai_emp_reinforce:message_on_rout_proportion("emp_reinforce_defeated", 0.99);

		gb:add_listener(
			"ritual_completed",
			function()
				if ga_ai_emp_reinforce.sunits:are_any_active_on_battlefield() == true then
					ga_ai_emp_reinforce.sunits:rout_over_time(5000);
				end;
			end,
			true
		);
		
		bm:out("Adding Empire units");
	else
		bm:out("The Empire reinforcement tracker is broken...");
	end
end

---------------------------------
-----CAMPAIGN ALLY BRETONNIA-----
---------------------------------

local ultimate_scheme_bretonnia = tonumber(core:svr_load_string("the_changeling_bretonnia_army_reinforce"))
 
function spawn_bretonnia_campaign_army()
	if ultimate_scheme_bretonnia == 1 then
		gb:message_on_time_offset("brt_reinforce_defeated", 100);
		bm:out("Not adding Bretonnia units");
	elseif ultimate_scheme_bretonnia == 0 then
	ga_ai_brt_reinforce:reinforce_on_message("call_brt_reinforce");
	ga_ai_brt_reinforce:get_army():suppress_reinforcement_adc(1);

	ga_ai_brt_reinforce:message_on_any_deployed("brt_reinforce_in");
	ga_ai_brt_reinforce:rush_on_message("brt_reinforce_in");
	gb:queue_help_on_message("brt_reinforce_in", "wh3_dlc24_tze_changeling_theatre_scheme_ultimate_hint_brt");

	ga_ai_brt_reinforce:message_on_rout_proportion("brt_reinforce_defeated", 0.99);

	gb:add_listener(
		"ritual_completed",
		function()
			if ga_ai_brt_reinforce.sunits:are_any_active_on_battlefield() == true then
				ga_ai_brt_reinforce.sunits:rout_over_time(5000);
			end;
		end,
		true
	);
	
	bm:out("Adding Bretonnia units");
	else
		bm:out("The Bretonnia reinforcement tracker is broken...");
	end
end

------------------------------
-----CAMPAIGN ALLY CATHAY-----
------------------------------

local ultimate_scheme_cathay = tonumber(core:svr_load_string("the_changeling_cathay_army_reinforce"))
 
function spawn_cathay_campaign_army()
	if ultimate_scheme_cathay == 1 then
		gb:message_on_time_offset("cth_reinforce_defeated", 100);
		bm:out("Not adding Cathay units");
	elseif ultimate_scheme_cathay == 0 then
		ga_ai_cth_reinforce:reinforce_on_message("call_cth_reinforce");
		ga_ai_cth_reinforce:get_army():suppress_reinforcement_adc(1);

		ga_ai_cth_reinforce:message_on_any_deployed("cth_reinforce_in");
		ga_ai_cth_reinforce:rush_on_message("cth_reinforce_in");
		gb:queue_help_on_message("cth_reinforce_in", "wh3_dlc24_tze_changeling_theatre_scheme_ultimate_hint_cth");

		ga_ai_cth_reinforce:message_on_rout_proportion("cth_reinforce_defeated", 0.99);

		gb:add_listener(
			"ritual_completed",
			function()
				if ga_ai_cth_reinforce.sunits:are_any_active_on_battlefield() == true then
					ga_ai_cth_reinforce.sunits:rout_over_time(5000);
				end;
			end,
			true
		);
		
		bm:out("Adding Cathay units");
	else
		bm:out("The Cathay reinforcement tracker is broken...");
	end
end

----------------------------------
-----CAMPAIGN ALLY HIGH ELVES-----
----------------------------------

local ultimate_scheme_high_elves = tonumber(core:svr_load_string("the_changeling_high_elves_army_reinforce"))
 
function spawn_high_elves_campaign_army()
	if ultimate_scheme_high_elves == 1 then
		gb:message_on_time_offset("hef_reinforce_defeated", 100);
		bm:out("Not adding High Elves units");
	elseif ultimate_scheme_high_elves == 0 then
		ga_ai_hef_reinforce:reinforce_on_message("call_hef_reinforce");
		ga_ai_hef_reinforce:get_army():suppress_reinforcement_adc(1);

		ga_ai_hef_reinforce:message_on_any_deployed("hef_reinforce_in");
		ga_ai_hef_reinforce:rush_on_message("hef_reinforce_in");
		gb:queue_help_on_message("hef_reinforce_in", "wh3_dlc24_tze_changeling_theatre_scheme_ultimate_hint_hef");

		ga_ai_hef_reinforce:message_on_rout_proportion("hef_reinforce_defeated", 0.99);

		gb:add_listener(
			"ritual_completed",
			function()
				if ga_ai_hef_reinforce.sunits:are_any_active_on_battlefield() == true then
					ga_ai_hef_reinforce.sunits:rout_over_time(5000);
				end;
			end,
			true
		);
		
		bm:out("Adding High Elves units");
	else
		bm:out("The High Elves reinforcement tracker is broken...");
	end
end

--------------------------------------
-----CAMPAIGN ENEMY VAMPIRE COAST-----
--------------------------------------

local ultimate_scheme_vampire_coast = tonumber(core:svr_load_string("the_changeling_vampire_coast_army_reinforce"))
 
function spawn_vampire_coast_campaign_army()
	if ultimate_scheme_vampire_coast == 1 then
		
		ga_ally_cst_reinforce:deploy_at_random_intervals_on_message(
			"call_cst_reinforce",	 	-- message
			1, 							-- min units
			1, 							-- max units
			10000, 						-- min period
			10000, 						-- max period
			nil,				 		-- cancel message
			nil,						-- spawn first wave immediately
			false,						-- allow respawning
			nil,						-- survival battle wave index
			nil,						-- is final survival wave
			false						-- show debug output
		);
		
		ga_ally_cst_reinforce:reinforce_on_message("call_cst_reinforce");
		ga_ally_cst_reinforce:get_army():suppress_reinforcement_adc(1);

		ga_ally_cst_reinforce:message_on_any_deployed("cst_reinforce_in");
		ga_ally_cst_reinforce:rush_on_message("cst_reinforce_in");
		gb:queue_help_on_message("cst_reinforce_in", "wh3_dlc24_tze_changeling_theatre_scheme_ultimate_hint_cst");

		ga_ally_cst_reinforce:message_on_rout_proportion("cst_reinforce_defeated", 0.99);

		gb:add_listener(
			"ritual_failed",
			function()
				if ga_ally_cst_reinforce.sunits:are_any_active_on_battlefield() == true then
					ga_ally_cst_reinforce.sunits:rout_over_time(5000);
				end;
			end,
			true
		);
		
		bm:out("Adding Vampire Coast units");
	elseif ultimate_scheme_vampire_coast == 0 then
		gb:message_on_time_offset("cst_reinforce_defeated", 100);
		bm:out("Not adding Vampire Coast units");
	else
		bm:out("The Vampire Coast reinforcement tracker is broken...");
	end
end

-----------------------------------
-----CAMPAIGN ENEMY GREENSKINS-----
-----------------------------------

local ultimate_scheme_greenskins = tonumber(core:svr_load_string("the_changeling_greenskins_army_reinforce"))
 
function spawn_greenskins_campaign_army()
	if ultimate_scheme_greenskins == 1 then
		ga_ally_grn_reinforce:reinforce_on_message("call_grn_reinforce");
		ga_ally_grn_reinforce:get_army():suppress_reinforcement_adc(1);

		ga_ally_grn_reinforce:message_on_any_deployed("grn_reinforce_in");
		ga_ally_grn_reinforce:rush_on_message("grn_reinforce_in");
		gb:queue_help_on_message("grn_reinforce_in", "wh3_dlc24_tze_changeling_theatre_scheme_ultimate_hint_grn");

		ga_ally_grn_reinforce:message_on_rout_proportion("grn_reinforce_defeated", 0.99);

		gb:add_listener(
			"ritual_failed",
			function()
				if ga_ally_grn_reinforce.sunits:are_any_active_on_battlefield() == true then
					ga_ally_grn_reinforce.sunits:rout_over_time(5000);
				end;
			end,
			true
		);
		
		bm:out("Adding Greenskins units");
	elseif ultimate_scheme_greenskins == 0 then
		gb:message_on_time_offset("grn_reinforce_defeated", 100);
		bm:out("Not adding Greenskins units");
	else
		bm:out("The Greenskins reinforcement tracker is broken...");
	end
end

-------------------------------
-----CAMPAIGN ENEMY NORSCA-----
-------------------------------

local ultimate_scheme_norsca = tonumber(core:svr_load_string("the_changeling_norsca_army_reinforce"))
 
function spawn_norsca_campaign_army()
	if ultimate_scheme_norsca == 1 then
		
		ga_ally_nor_reinforce:deploy_at_random_intervals_on_message(
			"call_nor_reinforce",	 	-- message
			1, 							-- min units
			1, 							-- max units
			5000, 						-- min period
			5000, 						-- max period
			nil,				 		-- cancel message
			nil,						-- spawn first wave immediately
			false,						-- allow respawning
			nil,						-- survival battle wave index
			nil,						-- is final survival wave
			false						-- show debug output
		);
		
		ga_ally_nor_reinforce:reinforce_on_message("call_nor_reinforce");
		ga_ally_nor_reinforce:get_army():suppress_reinforcement_adc(1);

		ga_ally_nor_reinforce:message_on_any_deployed("nor_reinforce_in");
		ga_ally_nor_reinforce:rush_on_message("nor_reinforce_in");
		gb:queue_help_on_message("nor_reinforce_in", "wh3_dlc24_tze_changeling_theatre_scheme_ultimate_hint_nor");

		ga_ally_nor_reinforce:message_on_rout_proportion("nor_reinforce_defeated", 0.99);

		gb:add_listener(
			"ritual_failed",
			function()
				if ga_ally_nor_reinforce.sunits:are_any_active_on_battlefield() == true then
					ga_ally_nor_reinforce.sunits:rout_over_time(5000);
				end;
			end,
			true
		);
		
		bm:out("Adding Norsca units");
	elseif ultimate_scheme_norsca == 0 then
		gb:message_on_time_offset("nor_reinforce_defeated", 100);
		bm:out("Not adding Norsca units");
	else
		bm:out("The Norsca reinforcement tracker is broken...");
	end
end

-------------------------------
-----CAMPAIGN ENEMY SKAVEN-----
-------------------------------

local ultimate_scheme_skaven = tonumber(core:svr_load_string("the_changeling_skaven_army_reinforce"))
 
function spawn_skaven_campaign_army()
	if ultimate_scheme_skaven == 1 then
		ga_ally_skv_reinforce:reinforce_on_message("call_skv_reinforce");
		ga_ally_skv_reinforce:get_army():suppress_reinforcement_adc(1);

		ga_ally_skv_reinforce:message_on_any_deployed("skv_reinforce_in");
		ga_ally_skv_reinforce:rush_on_message("skv_reinforce_in");
		gb:queue_help_on_message("skv_reinforce_in", "wh3_dlc24_tze_changeling_theatre_scheme_ultimate_hint_skv");

		ga_ally_skv_reinforce:message_on_rout_proportion("skv_reinforce_defeated", 0.99);

		gb:add_listener(
			"ritual_failed",
			function()
				if ga_ally_skv_reinforce.sunits:are_any_active_on_battlefield() == true then
					ga_ally_skv_reinforce.sunits:rout_over_time(5000);
				end;
			end,
			true
		);
		
		bm:out("Adding Skaven units");
	elseif ultimate_scheme_skaven == 0 then
		gb:message_on_time_offset("skv_reinforce_defeated", 100);
		bm:out("Not adding Skaven units");
	else
		bm:out("The Skaven reinforcement tracker is broken...");
	end
end

-----------------------------------
-----CAMPAIGN ENEMY TOMB KINGS-----
-----------------------------------

local ultimate_scheme_tomb_kings = tonumber(core:svr_load_string("the_changeling_tomb_kings_army_reinforce"))
 
function spawn_tomb_kings_campaign_army()
	if ultimate_scheme_tomb_kings == 1 then
		ga_ally_tmb_reinforce:reinforce_on_message("call_tmb_reinforce");
		ga_ally_tmb_reinforce:get_army():suppress_reinforcement_adc(1);

		ga_ally_tmb_reinforce:message_on_any_deployed("tmb_reinforce_in");
		ga_ally_tmb_reinforce:rush_on_message("tmb_reinforce_in");
		gb:queue_help_on_message("tmb_reinforce_in", "wh3_dlc24_tze_changeling_theatre_scheme_ultimate_hint_tmb");

		ga_ally_tmb_reinforce:message_on_rout_proportion("tmb_reinforce_defeated", 0.99);

		gb:add_listener(
			"ritual_failed",
			function()
				if ga_ally_tmb_reinforce.sunits:are_any_active_on_battlefield() == true then
					ga_ally_tmb_reinforce.sunits:rout_over_time(5000);
				end;
			end,
			true
		);
		
		bm:out("Adding Tomb Kings units");
	elseif ultimate_scheme_tomb_kings == 0 then
		gb:message_on_time_offset("tmb_reinforce_defeated", 100);
		bm:out("Not adding Tomb Kings units");
	else
		bm:out("The Tomb Kings reinforcement tracker is broken...");
	end
end

if bm:is_from_campaign() then
	spawn_empire_campaign_army()
	spawn_bretonnia_campaign_army()
	spawn_cathay_campaign_army()
	spawn_high_elves_campaign_army()

	spawn_vampire_coast_campaign_army()
	spawn_greenskins_campaign_army()
	spawn_norsca_campaign_army()
	spawn_skaven_campaign_army()
	spawn_tomb_kings_campaign_army()
end

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player_01:message_on_rout_proportion("changeling_dead", 1.0);

ga_ai_start_emp:force_victory_on_message("changeling_dead", 5000);
ga_ai_start_emp:force_victory_on_message("all_casters_dead", 5000);

ga_player_01:force_victory_on_message("ritual_completed", 5000);