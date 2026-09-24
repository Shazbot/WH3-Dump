-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Boris Todbringer
-- The Final Duel
-- Middenheim
-- Attacking

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------

load_script_libraries();
local sm = get_messager();
bm:camera():fade(false, 0);

gb = generated_battle:new(
	false,                                      		    -- screen starts black
	false,                                      		-- prevent deployment for player
	true,                                      		    -- prevent deployment for ai
	function() end_deployment_phase() end,          	-- intro cutscene function
	false                                      			-- debug mode
);


gb:set_cutscene_during_deployment(true)

--preload stuttering fix
intro_cinematic_file = "script/battle/quest_battles/_cutscene/managers/wh3_todbringer_fb_intro_01.CindySceneManager";
bm:cindy_preload(intro_cinematic_file); 
-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

--local sfx_cutscene_sweetener_intro = new_sfx("Play_Movie_WH3_DLC26_QB_Tower_Of_Ashshair_Intro", true, false)
--local sfx_cutscene_sweetener_intro_stop = new_sfx("Stop_Movie_WH3_DLC26_QB_Tower_Of_Ashshair_Intro", false, false)




---------------------------------------
----------WEF REINS FROM CAM-----------
---------------------------------------
local wef_reinforcements_camp = core:svr_load_bool("sbool_wh3_dlc29_middenland_boris_final_battle_reinforcements_enabled")



-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------
ga_player = gb:get_army(gb:get_player_alliance_num())
boris = ga_player.sunits:item(1)

--Allied EMP GARRISON
ga_ai_ally_emp_defenders = gb:get_army(gb:get_player_alliance_num(), "emp_defenders");

ga_ai_ally_emp_reinforcements = gb:get_army(gb:get_player_alliance_num(), "emp_reinforcements");


--Allied WEF ARMY
if wef_reinforcements_camp == true then ga_ai_ally_wef = gb:get_army(gb:get_player_alliance_num(), "wef_reinforcements"); end
if bm:is_from_campaign()==false then ga_ai_ally_wef = gb:get_army(gb:get_player_alliance_num(), "wef_reinforcements"); end




enemy_script_ids = {
	"enemy_army",
	"bst_reinforcement_1",
	"bst_reinforcement_2",
	"nur_reinforcements",
	"sla_reinforcements",
	"kho_reinforcements",
	"tze_reinforcements",
	"bray_nur",
	"bray_sla",
	"bray_kho",
	"bray_tze"
}

enemy_armies = {
	bray_nur = {army= gb:get_army(gb:get_non_player_alliance_num(), "bray_nur"), visible= true, winds=30, proximity=125, death_message="bray_nur_dead"},
	bray_sla = {army= gb:get_army(gb:get_non_player_alliance_num(), "bray_sla"), visible= true, winds=30, proximity=125, death_message="bray_sla_dead"},
	bray_kho = {army= gb:get_army(gb:get_non_player_alliance_num(), "bray_kho"), visible= true, winds=30, proximity=125, death_message="bray_kho_dead"},
	bray_tze = {army= gb:get_army(gb:get_non_player_alliance_num(), "bray_tze"), visible= true, winds=30, proximity=125, death_message="bray_tze_dead"},
	nur_reinforcements = {army= gb:get_army(gb:get_non_player_alliance_num(), "nur_reinforcements"), visible= nil, deployment_ids = bm:get_spawn_zone_collection_by_name("nur_reinforcements"), message="nur_reinforcements", cancel_message="bray_nur_dead"},
	sla_reinforcements = {army= gb:get_army(gb:get_non_player_alliance_num(), "sla_reinforcements"), visible= nil, deployment_ids = bm:get_spawn_zone_collection_by_name("sla_reinforcements"),  message="sla_reinforcements", cancel_message="bray_sla_dead"},
	kho_reinforcements = {army= gb:get_army(gb:get_non_player_alliance_num(), "kho_reinforcements"), visible= nil, deployment_ids  =bm:get_spawn_zone_collection_by_name("kho_reinforcements"), message="kho_reinforcements", cancel_message="bray_kho_dead"},
	tze_reinforcements = {army= gb:get_army(gb:get_non_player_alliance_num(), "tze_reinforcements"), visible= nil, deployment_ids = bm:get_spawn_zone_collection_by_name("tze_reinforcements"), message="tze_reinforcements", cancel_message="bray_tze_dead"},
	enemy_army = {army= gb:get_army(gb:get_non_player_alliance_num(), "bst_starting_army"), unbreakable=false, visible= false, spawn_zone = nil, cancel_message="bstmen_stop", winds=30},
	bst_reinforcement_1 = {army= gb:get_army(gb:get_non_player_alliance_num(), "bst_reinforcement_1"), unbreakable=false, visible= false, deployment_ids = bm:get_spawn_zone_collection_by_name("bst_reinforcement_2"), winds=30},
	bst_reinforcement_2 = {army= gb:get_army(gb:get_non_player_alliance_num(), "bst_reinforcement_2"), unbreakable=false, visible= false, deployment_ids = bm:get_spawn_zone_collection_by_name("bst_reinforcement_2"), winds=30}
}


khazrak = enemy_armies.bst_reinforcement_1.army.sunits:item(1)

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
------------------------------------------- CUTSCENE --------------------------------------------
-------------------------------------------------------------------------------------------------



function end_deployment_phase()
	bm:out("\tend_deployment_phase() called");
		
	local cam = bm:camera();
	
	local cutscene_intro = cutscene:new_from_cindyscene(
		"cutscene_intro", 																				-- unique string name for cutscene
		ga_player.sunits,																				-- unitcontroller over player's army
		function() intro_cutscene_end() end,															-- what to call when cutscene is finished
		"script/battle/quest_battles/_cutscene/managers/wh3_todbringer_fb_intro_01.CindySceneManager",	 	-- path to cindyscene
		0,																								-- blend in time (s)
		0																								-- blend out time (s)
	)
	
	ga_player.sunits:get_general_sunit():set_invisible_to_all(true);
	
	-- set up subtitles
	local subtitles = cutscene_intro:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();
	
	cutscene_intro:set_post_cutscene_fade_time(0);
	
	-- skip callback
	cutscene_intro:set_skippable(
		true, 
		function()
			local cam = bm:camera();
			cam:fade(true, 0);
			bm:stop_cindy_playback(true);
			bm:callback(function() cam:fade(false, 0.5) end, 500);
		end
	);
	
	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(false, 1) end, 1000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(new_sfx("Play_Movie_WH3_DLC29_FB_Boris_Intro", true, false)) end, 100);
	
	cutscene_intro:action(
		function()
			enemy_armies.enemy_army.army.sunits:set_always_visible(true);
		end,
		200
	)
	
	-- cutscene_intro:action(function() cam:move_to(v(-781.747, 84.081, 5.09), v(-770.503, 81.635, 21.587), 0, false, 30) end, 0);	
--[[
	cutscene_intro:action(function() bm:cindy_playback("script/battle/quest_battles/_cutscene/managers/sot.CindySceneManager", true) end, 200);
	cutscene_intro:action(
		function()
			player_units_hidden = false;
			ga_defender_01:set_enabled(true) 
		end, 
		200
	);	
	cutscene_intro:action(
		function() 
			player_units_hidden = false;
			ga_defender_01:set_enabled(true) 
		end, 
		25000
	);		
	]]--
	-- Voiceover and Subtitles --
		cutscene_intro:add_cinematic_trigger_listener(
			"Play_wh3_dlc29_emp_boris_the_final_dual_01", 
				function()
					cutscene_intro:play_sound(new_sfx("Play_wh3_dlc29_emp_boris_the_final_dual_01"))
					bm:show_subtitle("wh3_dlc29_emp_boris_todbringer_final_duel_intro_01", false, true)
				end
		)
		cutscene_intro:add_cinematic_trigger_listener(
			"Play_wh3_dlc29_bst_khazrak_the_final_dual_02", 
				function()
					cutscene_intro:play_sound(new_sfx("Play_wh3_dlc29_bst_khazrak_the_final_dual_02"))
					bm:show_subtitle("wh3_dlc29_emp_boris_todbringer_final_duel_intro_02", false, true)
				end
		)

		cutscene_intro:add_cinematic_trigger_listener(
			"Play_wh3_dlc29_emp_boris_the_final_dual_03", 
				function()
					cutscene_intro:play_sound(new_sfx("Play_wh3_dlc29_emp_boris_the_final_dual_03"))
					bm:show_subtitle("wh3_dlc29_emp_boris_todbringer_final_duel_intro_03", false, true)
				end
		)
		cutscene_intro:add_cinematic_trigger_listener(
			"Play_wh3_dlc29_emp_boris_the_final_dual_04", 
				function()
					cutscene_intro:play_sound(new_sfx("Play_wh3_dlc29_emp_boris_the_final_dual_04"))
					bm:show_subtitle("wh3_dlc29_emp_boris_todbringer_final_duel_intro_04", false, true)
				end
		)
		cutscene_intro:add_cinematic_trigger_listener(
			"Play_wh3_dlc29_emp_boris_the_final_dual_05", 
				function()
					cutscene_intro:play_sound(new_sfx("Play_wh3_dlc29_emp_boris_the_final_dual_05"))
					bm:show_subtitle("wh3_dlc29_emp_boris_todbringer_final_duel_intro_05", false, true)
				end
		)
		cutscene_intro:add_cinematic_trigger_listener(
			"Play_wh3_dlc29_emp_boris_the_final_dual_06", 
				function()
					cutscene_intro:play_sound(new_sfx("Play_wh3_dlc29_emp_boris_the_final_dual_06"))
					bm:show_subtitle("wh3_dlc29_emp_boris_todbringer_final_duel_intro_06", false, true)
					ga_player.sunits:get_general_sunit():set_invisible_to_all(false);
				end
		)cutscene_intro:add_cinematic_trigger_listener(
			"boris_start_position", 
				function()
					ga_player.sunits:get_general_sunit():set_invisible_to_all(false);
				end
		)


	cutscene_intro:start();
end;



function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end")
	ga_player.sunits:get_general_sunit():set_invisible_to_all(false);
	cam:fade(true, 0);
	cam:fade(false, 0);
	bm:hide_subtitles()
end;


--------------------------
-----COMPOSITE SCENES-----
--------------------------
nur_portal_01 = "composite_scene/wh3_main_nurgle_gate_portal.csc";
sla_portal_01 = "composite_scene/wh3_main_slaanesh_gate_portal.csc";
kho_portal_01 = "composite_scene/wh3_main_khorne_gate_portal.csc";
tze_portal_01 = "composite_scene/wh3_main_tzeentch_gate_portal.csc";

nur_portal_02 = "composite_scene/wh3_dlc29_nurgle_portal_loop.csc";
sla_portal_02 = "composite_scene/wh3_dlc29_slaanesh_portal_loop.csc";
kho_portal_02 = "composite_scene/wh3_main_khorne_gate_portal_loop.csc";
tze_portal_02 = "composite_scene/wh3_dlc29_tzeentch_portal_loop.csc";

-------------------------------------------------------------------------------------------------
---------------------------------------- REINFORCEMENTS -----------------------------------------
-------------------------------------------------------------------------------------------------
local dead_shamans = 0 -- int

function battle_start_teleport_units()
	bm:out("\tbattle_start_teleport_units() called")
	----------------------------------- ENEMY DEPLOYMENT SETUP -------------------------------------
		
	--- Bray Shaman Nur
	enemy_armies.bray_nur.army.sunits:item(1).uc:teleport_to_location(v(350.5, -140.5), -56.9, 1.5)
	enemy_armies.bray_nur.army.sunits:item(2).uc:teleport_to_location(v(316, -93), -56.9, 30)
	enemy_armies.bray_nur.army.sunits:item(3).uc:teleport_to_location(v(284, -140), -56.9, 30)
	enemy_armies.bray_nur.army.sunits:item(4).uc:teleport_to_location(v(263, -173), -56.9, 30)

	--- Bray Shaman Sla
	enemy_armies.bray_sla.army.sunits:item(1).uc:teleport_to_location(v(402, -363), -24, 1.5)
	enemy_armies.bray_sla.army.sunits:item(2).uc:teleport_to_location(v(409, -313), -45, 30)
	enemy_armies.bray_sla.army.sunits:item(3).uc:teleport_to_location(v(370, -373), -45, 30)
	enemy_armies.bray_sla.army.sunits:item(4).uc:teleport_to_location(v(355, -405), -45, 30)
	
	--- Bray Shaman Kho
	enemy_armies.bray_kho.army.sunits:item(1).uc:teleport_to_location(v(-240, -142), 45, 1.5)
	enemy_armies.bray_kho.army.sunits:item(2).uc:teleport_to_location(v(-159, -153), 45, 30)
	enemy_armies.bray_kho.army.sunits:item(3).uc:teleport_to_location(v(-183, -119), 45, 30)
	enemy_armies.bray_kho.army.sunits:item(4).uc:teleport_to_location(v(-209, -96), 45, 30)

	--- Bray Shaman Tze
	enemy_armies.bray_tze.army.sunits:item(1).uc:teleport_to_location(v(-24, -399), 20, 1.5)
	enemy_armies.bray_tze.army.sunits:item(2).uc:teleport_to_location(v(-1, -371), 0, 30)
	enemy_armies.bray_tze.army.sunits:item(3).uc:teleport_to_location(v(-50, -371), 0, 30)
	enemy_armies.bray_tze.army.sunits:item(4).uc:teleport_to_location(v(-80, -371), 0, 30)
	
end
battle_start_teleport_units() 



 
-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------
gb:message_on_time_offset("reinforcements", 150000)
gb:message_on_time_offset("start", 2000)
gb:message_on_time_offset("bray_shaman", 2010)

gb:message_on_time_offset("emp_reinforcements", 1000, "start")
gb:message_on_time_offset("emp_reinforcements", 180000)

gb:message_on_time_offset("wef_reinforcements", 60000, "wef_reinforcement_delay")

enemy_armies.enemy_army.army:message_on_under_attack("under_fire")
enemy_armies.enemy_army.army:attack_force_on_message("start", ga_player)
enemy_armies.enemy_army.army:rush_on_message("under_fire")
enemy_armies.enemy_army.army:rush_on_message("start")
enemy_armies.enemy_army.army:rush_on_message("trigger_ambush")
enemy_armies.bst_reinforcement_1.army:rush_on_message("start")
enemy_armies.bst_reinforcement_1.army:rush_on_message("start")


ga_ai_ally_emp_defenders:defend_on_message("start", 28, 186.6, 100)
enemy_armies.bst_reinforcement_1.army:message_on_proximity_to_enemy("wef_reinforcement_delay", 50)

bray_shaman_nur = enemy_armies.bray_nur.army.sunits:item(1);
bray_shaman_nur:set_stat_attribute("unbreakable", true);

bray_shaman_kho = enemy_armies.bray_kho.army.sunits:item(1);
bray_shaman_kho:set_stat_attribute("unbreakable", true);

bray_shaman_sla = enemy_armies.bray_sla.army.sunits:item(1);
bray_shaman_sla:set_stat_attribute("unbreakable", true);

bray_shaman_tze = enemy_armies.bray_tze.army.sunits:item(1);
bray_shaman_tze:set_stat_attribute("unbreakable", true);




-------------------------------------------------------------------------------------------------
------------------------------------------- REINFORCEMENTS FLOW ---------------------------------
-------------------------------------------------------------------------------------------------

enemy_armies.nur_reinforcements.army:assign_to_spawn_zone_from_collection_on_message("reinforcements", enemy_armies.nur_reinforcements.deployment_ids, false)
enemy_armies.sla_reinforcements.army:assign_to_spawn_zone_from_collection_on_message("reinforcements", enemy_armies.sla_reinforcements.deployment_ids, false)
enemy_armies.kho_reinforcements.army:assign_to_spawn_zone_from_collection_on_message("reinforcements", enemy_armies.kho_reinforcements.deployment_ids, false)
enemy_armies.tze_reinforcements.army:assign_to_spawn_zone_from_collection_on_message("reinforcements", enemy_armies.tze_reinforcements.deployment_ids, false)
enemy_armies.bst_reinforcement_1.army:assign_to_spawn_zone_from_collection_on_message("bray_tze_dead", enemy_armies.bst_reinforcement_1.deployment_ids, false)


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

deploy_reinforcements(enemy_armies.nur_reinforcements.army, spawn_flows[1], enemy_armies.nur_reinforcements.cancel_message)
deploy_reinforcements(enemy_armies.sla_reinforcements.army, spawn_flows[1], enemy_armies.sla_reinforcements.cancel_message)
deploy_reinforcements(enemy_armies.kho_reinforcements.army, spawn_flows[1], enemy_armies.kho_reinforcements.cancel_message)
deploy_reinforcements(enemy_armies.tze_reinforcements.army, spawn_flows[1], enemy_armies.tze_reinforcements.cancel_message)



gb:add_listener(
	"01_intro_cutscene_end",
	function()
		bm:start_terrain_composite_scene(nur_portal_01, nil, 0);
		bm:start_terrain_composite_scene(sla_portal_01, nil, 0);
		bm:start_terrain_composite_scene(kho_portal_01, nil, 0);
		bm:start_terrain_composite_scene(tze_portal_01, nil, 0);
	end,
	true
);


gb:message_on_time_offset("start_portals_02", 7500, "01_intro_cutscene_end")


gb:add_listener(
	"start_portals_02",
	function()
		bm:start_terrain_composite_scene(nur_portal_02, nil, 0);
		bm:start_terrain_composite_scene(sla_portal_02, nil, 0);
		bm:start_terrain_composite_scene(kho_portal_02, nil, 0);
		bm:start_terrain_composite_scene(tze_portal_02, nil, 0);
	end,
	true
);


gb:stop_terrain_composite_scene_on_message(
	enemy_armies.nur_reinforcements.cancel_message,
	nur_portal_01,
	100
)

gb:stop_terrain_composite_scene_on_message(
	enemy_armies.sla_reinforcements.cancel_message,
	sla_portal_01,
	100
)

gb:stop_terrain_composite_scene_on_message(
	enemy_armies.kho_reinforcements.cancel_message,
	kho_portal_01,
	100
)
gb:stop_terrain_composite_scene_on_message(
	enemy_armies.tze_reinforcements.cancel_message,
	tze_portal_01,
	100
)
gb:stop_terrain_composite_scene_on_message(
	enemy_armies.nur_reinforcements.cancel_message,
	nur_portal_02,
	100
)

gb:stop_terrain_composite_scene_on_message(
	enemy_armies.sla_reinforcements.cancel_message,
	sla_portal_02,
	100
)

gb:stop_terrain_composite_scene_on_message(
	enemy_armies.kho_reinforcements.cancel_message,
	kho_portal_02,
	100
)
gb:stop_terrain_composite_scene_on_message(
	enemy_armies.tze_reinforcements.cancel_message,
	tze_portal_02,
	100
)
--[[
gb:add_listener(
	enemy_armies.nur_reinforcements.cancel_message,
	function()
		bm:stop_terrain_composite_scene("composite_scene/wh3_main_nurgle_gate_portal.csc");	
	end,
	true
);]]--


function deploy_bst_reinforcements(army, reinforcement_line)
	army:assign_to_spawn_zone_from_collection_on_message("start", reinforcement_line, false);
	army:deploy_at_random_intervals_on_message(
		"trigger_ambush", -- message
		6, -- min units
		6, -- max units
		100, -- min period
		400, -- max period
		"ambush_failed", -- cancel message
		nil, -- spawn first wave immediately
		false, -- allow respawning
		nil, -- survival battle wave index
		nil, -- is final survival wave
		false -- show debug output
	)
end

reinformcement_zone_bst_1 = bm:get_spawn_zone_collection_by_name("bst_reinforcement_1")
reinformcement_zone_bst_2 = bm:get_spawn_zone_collection_by_name("bst_reinforcement_2")
deploy_bst_reinforcements(enemy_armies.bst_reinforcement_1.army, reinformcement_zone_bst_1)
deploy_bst_reinforcements(enemy_armies.bst_reinforcement_2.army, reinformcement_zone_bst_2)

khazrak_unit = enemy_armies.bst_reinforcement_1.army.sunits:item(1);
khazrak_unit:set_stat_attribute("unbreakable", true);

-- call enemy reinforcements
gb:queue_help_on_message("reinforcements", "wh3_dlc29_qb_emp_boris_todbringer_final_duel_hint_01")



---- EMP REINFORCEMENTS
reinformcement_zone_emp = bm:get_spawn_zone_collection_by_name("emp_reinforcement")


function 
deploy_emp_reinforcements(army, reinforcement_zone)
	army:assign_to_spawn_zone_from_collection_on_message("start", reinforcement_zone, false);
	army:deploy_at_random_intervals_on_message(
		"start", -- message
		6, -- min units
		6, -- max units
		100, -- min period
		400, -- max period
		nil, -- cancel message
		true, -- spawn first wave immediately
		true, -- allow respawning
		nil, -- survival battle wave index
		nil, -- is final survival wave
		false -- show debug output
	)
end


deploy_emp_reinforcements(ga_ai_ally_emp_reinforcements, reinformcement_zone_emp)

ga_ai_ally_emp_reinforcements:defend_on_message("emp_reinforcements", 28, 186.6, 100)

---- WEF REINFORCEMENTS
if wef_reinforcements_camp == true then
	-- activate wef reinforcements from campaign here
	reinformcement_zone_wef = bm:get_spawn_zone_collection_by_name("wef_reinforcement")

	function deploy_wef_reinforcements(army, reinforcement_zone)
		army:assign_to_spawn_zone_from_collection_on_message("start", reinforcement_zone, false);
		army:deploy_at_random_intervals_on_message(
			"wef_reinforcements", -- message
			3, -- min units
			6, -- max units
			100, -- min period
			400, -- max period
			"boris_dead_or_shattered", -- cancel message
			nil, -- spawn first wave immediately
			false, -- allow respawning
			nil, -- survival battle wave index
			nil, -- is final survival wave
			false -- show debug output
		)
		gb:queue_help_on_message("wef_reinforcements", "wh3_dlc29_qb_emp_boris_todbringer_final_duel_hint_04", 5000)
	end

	deploy_wef_reinforcements(ga_ai_ally_wef, reinformcement_zone_wef)
end


if bm:is_from_campaign() == false then
	-- activate wef reinforcements from campaign here
	reinformcement_zone_wef = bm:get_spawn_zone_collection_by_name("wef_reinforcement")

	function deploy_wef_reinforcements(army, reinforcement_zone)
		army:assign_to_spawn_zone_from_collection_on_message("start", reinforcement_zone, false);
		army:deploy_at_random_intervals_on_message(
			"wef_reinforcements", -- message
			3, -- min units
			6, -- max units
			100, -- min period
			400, -- max period
			"boris_dead_or_shattered", -- cancel message
			nil, -- spawn first wave immediately
			false, -- allow respawning
			nil, -- survival battle wave index
			nil, -- is final survival wave
			false -- show debug output
		)
		gb:queue_help_on_message("wef_reinforcements", "wh3_dlc29_qb_emp_boris_todbringer_final_duel_hint_04", 5000)
	end

	deploy_wef_reinforcements(ga_ai_ally_wef, reinformcement_zone_wef)
end

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

			gb:add_listener(
				"trigger_ambush",
				function()
					army:attack()
					print("under_attack_ambush_triggered")
				end
			)

		elseif(armies.proximity and armies.proximity == 0) then
			army:attack()
		end
	end
end
setup_army_attack_proximities()


-------------------------------------------------------------------------------------------------
--------------------------------------------- Boris check ----------------------------
-------------------------------------------------------------------------------------------------
-- boris is dead
if boris then
	bm:watch(
	function()
			return is_shattered_or_dead(boris)
		end,
		0,
		function()
			bm:out("*** Boris is shattered or dead ***")
			gb.sm:trigger_message("boris_dead")

		end
	)
end



-------------------------------------------------------------------------------------------------
--------------------------------------------- Bray Shaman check ----------------------------
-------------------------------------------------------------------------------------------------

enemy_armies.bray_nur.army:message_on_commander_death(enemy_armies.bray_nur.death_message)
enemy_armies.bray_sla.army:message_on_commander_death(enemy_armies.bray_sla.death_message)
enemy_armies.bray_kho.army:message_on_commander_death(enemy_armies.bray_kho.death_message)
enemy_armies.bray_tze.army:message_on_commander_death(enemy_armies.bray_tze.death_message)

gb:add_listener(
	"bray_nur_dead",
	function ()
		dead_shamans = dead_shamans + 1
		print(dead_shamans)
		enemy_armies.bray_nur.army.sunits:morale_behavior_rout()
		enemy_armies.nur_reinforcements.army.sunits:morale_behavior_rout()
		if dead_shamans == 2 then sm:trigger_message("trigger_ambush") end
	end
);

gb:add_listener(
	"bray_kho_dead",
	function ()
		dead_shamans = dead_shamans + 1
		print(dead_shamans)
		enemy_armies.bray_kho.army.sunits:morale_behavior_rout()
		enemy_armies.kho_reinforcements.army.sunits:morale_behavior_rout()
		if dead_shamans == 2 then sm:trigger_message("trigger_ambush") end
	end
);
gb:add_listener(
	"bray_tze_dead",
	function ()
		dead_shamans = dead_shamans + 1
		print(dead_shamans)
		enemy_armies.bray_tze.army.sunits:morale_behavior_rout()
		enemy_armies.tze_reinforcements.army.sunits:morale_behavior_rout()
		if dead_shamans == 2 then sm:trigger_message("trigger_ambush") end
	end
);
gb:add_listener(
	"bray_sla_dead",
	function ()
		dead_shamans = dead_shamans + 1
		print(dead_shamans)
		enemy_armies.bray_sla.army.sunits:morale_behavior_rout()
		enemy_armies.sla_reinforcements.army.sunits:morale_behavior_rout()
		if dead_shamans == 2 then sm:trigger_message("trigger_ambush") end
	end
);



-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------

---Kill Bray Shamans 
gb:set_objective_on_message("01_intro_cutscene_end", "wh3_dlc29_qb_emp_boris_todbringer_final_objective_01", 500)
gb:queue_help_on_message("bray_shaman", "wh3_dlc29_qb_emp_boris_todbringer_final_duel_hint_02")

gb:set_objective_on_message("01_intro_cutscene_end", "wh3_dlc29_qb_emp_boris_todbringer_final_objective_03", 500)
gb:set_objective_on_message("trigger_ambush", "wh3_dlc29_qb_emp_boris_todbringer_final_objective_02", 5000)
gb:queue_help_on_message("trigger_ambush", "wh3_dlc29_qb_emp_boris_todbringer_final_duel_hint_03")

enemy_armies.bray_nur.army:add_ping_icon_on_message("bray_shaman", 5, 1)
enemy_armies.bray_sla.army:add_ping_icon_on_message("bray_shaman", 5, 1)
enemy_armies.bray_kho.army:add_ping_icon_on_message("bray_shaman", 5, 1)
enemy_armies.bray_tze.army:add_ping_icon_on_message("bray_shaman", 5, 1)

gb:set_locatable_objective_callback_on_message(
    "bray_shaman",
    "wh3_dlc29_qb_emp_boris_todbringer_final_duel_bray_shaman_01",
    7000,
    function()
        local sunit = enemy_armies.bray_nur.army.sunits:item(1);
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
    "bray_shaman",
    "wh3_dlc29_qb_emp_boris_todbringer_final_duel_bray_shaman_02",
    7000,
    function()
        local sunit = enemy_armies.bray_sla.army.sunits:item(1);
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
    "bray_shaman",
    "wh3_dlc29_qb_emp_boris_todbringer_final_duel_bray_shaman_03",
    7000,
    function()
        local sunit = enemy_armies.bray_kho.army.sunits:item(1);
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
    "bray_shaman",
    "wh3_dlc29_qb_emp_boris_todbringer_final_duel_bray_shaman_04",
    7000,
    function()
        local sunit = enemy_armies.bray_tze.army.sunits:item(1);
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


gb:complete_objective_on_message(enemy_armies.bray_nur.death_message, "wh3_dlc29_qb_emp_boris_todbringer_final_duel_bray_shaman_01")
gb:complete_objective_on_message(enemy_armies.bray_sla.death_message, "wh3_dlc29_qb_emp_boris_todbringer_final_duel_bray_shaman_02")
gb:complete_objective_on_message(enemy_armies.bray_kho.death_message, "wh3_dlc29_qb_emp_boris_todbringer_final_duel_bray_shaman_03")
gb:complete_objective_on_message(enemy_armies.bray_tze.death_message, "wh3_dlc29_qb_emp_boris_todbringer_final_duel_bray_shaman_04")

-- complete defeat shamans on message
gb:message_on_all_messages_received("ambush_failed", "enemy_army_1_defeated", "enemy_army_2_defeated")
gb:complete_objective_on_message("ambush_failed", "wh3_dlc29_qb_emp_boris_todbringer_final_objective_02")

gb:message_on_all_messages_received("enemy_army_1_defeated", "reinforcements_1", "khazrak_dead")

-- boris is dead

enemy_armies.bst_reinforcement_1.army:message_on_rout_proportion("reinforcements_1", 0.8)
enemy_armies.bst_reinforcement_1.army:message_on_commander_dead_or_shattered("khazrak_dead")

enemy_armies.bst_reinforcement_2.army:message_on_rout_proportion("enemy_army_2_defeated", 0.8)

gb:message_on_all_messages_received("all_shamans_dead", "bray_nur_dead", "bray_kho_dead", "bray_sla_dead", "bray_tze_dead")
gb:complete_objective_on_message("all_shamans_dead", "wh3_dlc29_qb_emp_boris_todbringer_final_objective_01")

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:queue_help_on_message("trigger_ambush", "wh3_dlc29_qb_emp_boris_todbringer_final_duel_hint_03", 1000)


-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------------------
--------------------------------------------- DEFEAT -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player:message_on_commander_dead_or_shattered("boris_dead_or_shattered")

gb:queue_help_on_message("boris_dead", "wh3_dlc29_qb_emp_boris_todbringer_final_duel_boris_dead", 4000)
gb:message_on_any_message_received("boris_dead_or_shattered","boris_dead")



gb:fail_objective_on_message("boris_dead_or_shattered", "wh3_dlc29_qb_emp_boris_todbringer_final_objective_03", 2000)
enemy_armies.enemy_army.army:force_victory_on_message("boris_dead_or_shattered", 3000)
gb:message_on_time_offset("force_defeat", 3000, "boris_dead_or_shattered")

gb:add_listener(
    "force_defeat",
    function()
        enemy_armies.enemy_army.army:get_alliance():force_battle_victory();
    end
);

-------------------------------------------------------------------------------------------------
------------------------------------------- VICTORY ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:complete_objective_on_message("victory", "wh3_dlc29_qb_emp_boris_todbringer_final_objective_03")
gb:complete_objective_on_message("victory", "wh3_dlc29_qb_emp_boris_todbringer_final_objective_01")
gb:message_on_all_messages_received("victory", enemy_armies.bray_nur.death_message, enemy_armies.bray_sla.death_message, enemy_armies.bray_kho.death_message, enemy_armies.bray_tze.death_message, "ambush_failed")
ga_player:force_victory_on_message("victory", 3000)

gb:message_on_time_offset("force_victory", 5000, "victory")

gb:add_listener(
    "force_victory",
    function()
        ga_player:get_alliance():force_battle_victory();
    end
);
