load_script_libraries();

bm = battle_manager:new(empire_battle:new());
local gc = generated_cutscene:new(true);

gb = generated_battle:new(
                false,                         -- screen starts black
                false,                         -- prevent deployment for player
                true,                          -- prevent deployment for ai
				function() 
					gb:start_generated_cutscene(gc)      	-- intro cutscene function

					ga_ai_enemy_wave_01_main:set_visible_to_all(true);
                end,
				false                                       -- debug mode
);

---------------------------------------
----------HARD SCRIPT VERSION----------
---------------------------------------
local sm = get_messager();
local reinforcements = bm:reinforcements();

-----------------------------
----SCRIPTED INTRO CAMERA----
-----------------------------
-- Have you come, little morsel, to bask and gape-drool before a tide that defies all stemming?
-- Breathe deep now the Warpstone dust, as it builds up beneath a flood of a thousand thousand ratmen feet – unquenched, renewed, and ceaseless – and know your squirm-scrambling has all been for nought.
-- For I have gazed beyond the Veil, and into the future.
-- It is a pall of fur-filth drawn over the corpse-ruin of the surface.
-- Gnawing on it.
-- FOREVER!
gc:add_element("Play_wh3_dlc29_endtimes_narrative_vermintide_skreech_005_1", "wh3_dlc29_endtimes_narrative_vermintide_skreech_005_1", "gc_orbit_90_medium_commander_front_right_close_low_01", 12250, false, false, false);
gc:add_element(nil, "wh3_dlc29_endtimes_narrative_vermintide_skreech_005_2", "gc_medium_enemy_army_pan_back_right_to_back_left_close_medium_01", 25250, false, false, false);
gc:add_element(nil, "wh3_dlc29_endtimes_narrative_vermintide_skreech_005_3", "gc_episodes_vermintide_cam", 17000, false, false, false);
gc:add_element(nil, "wh3_dlc29_endtimes_narrative_vermintide_skreech_005_4", "gc_medium_enemy_army_pan_front_right_to_front_left_far_high_01", 6000, true, false, false);

gb:set_cutscene_during_deployment(true);

-------------------------------------------------------------------------------------------------
-------------------------------------------ARMY SETUP--------------------------------------------
-------------------------------------------------------------------------------------------------
--Player
ga_player_01 = gb:get_army(gb:get_player_alliance_num(), 1);

--Wave 01 - 13th Seat - Grey Seer Clan - Basic Theme
ga_ai_enemy_wave_01_main = gb:get_army(gb:get_non_player_alliance_num(), "wave_01_main");

--Wave 02 - 12th Seat - Ikit Claw - Clan Skryre - Warlock Theme
ga_ai_enemy_wave_02_main = gb:get_army(gb:get_non_player_alliance_num(), "wave_02_main");

--Wave 03 - 11th Seat - Thrott the Unclean - Clan Moulder - Packlord ThemeSkavenslaves & Clanrats
ga_ai_enemy_wave_03_main = gb:get_army(gb:get_non_player_alliance_num(), "wave_03_main");

--Wave 04 - 10th Seat - Lord Skrolk - Clan Pestilens - Plague Theme
ga_ai_enemy_wave_04_main = gb:get_army(gb:get_non_player_alliance_num(), "wave_04_main");
ga_ai_enemy_wave_04_chaff = gb:get_army(gb:get_non_player_alliance_num(), "wave_04_chaff");

--Wave 05 - 9th Seat - Deathmaster Snikch - Clan Eshin - Assassin Theme
ga_ai_enemy_wave_05_main = gb:get_army(gb:get_non_player_alliance_num(), "wave_05_main");

--Wave 06 - 8th Seat - Lord Griznekt Mancarver - Clan Skab - Warrior Theme
ga_ai_enemy_wave_06_main = gb:get_army(gb:get_non_player_alliance_num(), "wave_06_main");

--Wave 07 - 7th Seat - Arch-Pontifex Sitch - Clan Morbidus - Plague/Packlord Theme
ga_ai_enemy_wave_07_main = gb:get_army(gb:get_non_player_alliance_num(), "wave_07_main");

--Wave 08 - 6th Seat -  Arch-Brutelord Hesh Vrakspine - Clan Krizzor - Dark Lands Creature/Packlord Theme
ga_ai_enemy_wave_08_main = gb:get_army(gb:get_non_player_alliance_num(), "wave_08_main");

--Wave 09 - 5th Seat - Warlord Vrisk Ironscratch - Clan Skurvy - Slaves/Assassin/Warlock Theme
ga_ai_enemy_wave_09_main = gb:get_army(gb:get_non_player_alliance_num(), "wave_09_main");
ga_ai_enemy_wave_09_chaff = gb:get_army(gb:get_non_player_alliance_num(), "wave_09_chaff");

--Wave 10 - 4th Seat - Paskrit the Vast - No Clan - Monster/Warrior Theme
ga_ai_enemy_wave_10_main = gb:get_army(gb:get_non_player_alliance_num(), "wave_10_main");

--Wave 11 - 3rd Seat - Tretch Craventail - Clan Rictus - Night Goblins/Slaves/Stormvermin Theme
ga_ai_enemy_wave_11_main = gb:get_army(gb:get_non_player_alliance_num(), "wave_11_main");
ga_ai_enemy_wave_11_chaff = gb:get_army(gb:get_non_player_alliance_num(), "wave_11_chaff");

--Wave 12 - 2nd Seat - Queek Headtaker - Clan Mors - Warrior Theme
ga_ai_enemy_wave_12_main = gb:get_army(gb:get_non_player_alliance_num(), "wave_12_main");

--Wave 13 - 1st Seat - Skreech Verminking/Thanquol - Clan Scruten - ??? Theme
ga_ai_enemy_wave_13_main = gb:get_army(gb:get_non_player_alliance_num(), "wave_13_main");

-------------------------------------------------------------------------------------------------
------------------------------------------SCRIPT UNITS-------------------------------------------
-------------------------------------------------------------------------------------------------
--Skreech Verminking
skreech_character = ga_ai_enemy_wave_13_main.sunits:item(1)

-------------------------------
----------SPAWN ZONES----------
-------------------------------
--Waves Reinforce
skv_slave_waves_reinforce = bm:get_spawn_zone_collection_by_name("skv_slave_waves");
skv_council_reinforce = bm:get_spawn_zone_collection_by_name("skv_wave_council");
skv_waves_01_reinforce = bm:get_spawn_zone_collection_by_name("skv_waves_01");
skv_waves_02_reinforce = bm:get_spawn_zone_collection_by_name("skv_waves_02");
skv_waves_03_reinforce = bm:get_spawn_zone_collection_by_name("skv_waves_03");
skv_waves_04_reinforce = bm:get_spawn_zone_collection_by_name("skv_waves_04");

-- Wave 02 - Clan Skryre
ga_ai_enemy_wave_02_main:assign_to_spawn_zone_from_collection_on_message("start", skv_waves_01_reinforce, false);

-- Wave 03 - Clan Moulder
ga_ai_enemy_wave_03_main:assign_to_spawn_zone_from_collection_on_message("start", skv_waves_02_reinforce, false);

-- Wave 04 - Clan Pestilens
ga_ai_enemy_wave_04_main:assign_to_spawn_zone_from_collection_on_message("start", skv_waves_03_reinforce, false);

-- Wave 05 - Clan Eshin
ga_ai_enemy_wave_05_main:assign_to_spawn_zone_from_collection_on_message("start", skv_waves_04_reinforce, false);

-- Wave 06 - Clan Skab
ga_ai_enemy_wave_06_main:assign_to_spawn_zone_from_collection_on_message("start", skv_waves_01_reinforce, false);

-- Wave 07 - Clan Morbidus
ga_ai_enemy_wave_07_main:assign_to_spawn_zone_from_collection_on_message("start", skv_waves_02_reinforce, false);

-- Wave 08 - Clan Krizzor
ga_ai_enemy_wave_08_main:assign_to_spawn_zone_from_collection_on_message("start", skv_waves_03_reinforce, false);

-- Wave 09 - Clan Skurvy
ga_ai_enemy_wave_09_main:assign_to_spawn_zone_from_collection_on_message("start", skv_waves_04_reinforce, false);

-- Wave 10 - Paskrit the Vast
ga_ai_enemy_wave_10_main:assign_to_spawn_zone_from_collection_on_message("start", skv_waves_01_reinforce, false);

-- Wave 11 - Clan Rictus
ga_ai_enemy_wave_11_main:assign_to_spawn_zone_from_collection_on_message("start", skv_waves_02_reinforce, false);

-- Wave 12 - Clan Mors
ga_ai_enemy_wave_12_main:assign_to_spawn_zone_from_collection_on_message("start", skv_waves_03_reinforce, false);

-- Wave 13 - Clan Scruten
ga_ai_enemy_wave_13_main:assign_to_spawn_zone_from_collection_on_message("start", skv_council_reinforce, false);

--Chaff Waves
ga_ai_enemy_wave_09_chaff:assign_to_spawn_zone_from_collection_on_message("start", skv_slave_waves_reinforce, false);
ga_ai_enemy_wave_09_chaff:message_on_number_deployed("wave_09_chaff_deployed", true, 1);
ga_ai_enemy_wave_09_chaff:assign_to_spawn_zone_from_collection_on_message("wave_09_chaff_deployed", skv_slave_waves_reinforce, false);

ga_ai_enemy_wave_11_chaff:assign_to_spawn_zone_from_collection_on_message("start", skv_slave_waves_reinforce, false);
ga_ai_enemy_wave_11_chaff:message_on_number_deployed("wave_11_chaff_deployed", true, 1);
ga_ai_enemy_wave_11_chaff:assign_to_spawn_zone_from_collection_on_message("wave_11_chaff_deployed", skv_slave_waves_reinforce, false);

--Reinforcement Lines
for i = 1, reinforcements:defender_reinforcement_lines_count() do
	
	local line = reinforcements:defender_reinforcement_line(i);
	
	if (line:script_id() == "skv_slave_waves") then
		line:enable_random_deployment_position();		
	end
end;

-------------------------------------------
----------CAPTURE POINT LOCATIONS----------
-------------------------------------------
local main_cp = bm:capture_location_manager():capture_location_from_script_id("main_cp");

gb:message_on_capture_location_capture_completed("cp_main_stolen", "start", "main_cp", nil, nil, ga_ai_enemy_wave_01_main);

--------------------------------------
----------HINTS & OBJECTIVES----------
--------------------------------------
-----OBJECTIVE 0-----
-- Defeat Skreech Verminking - Dismantle the Council of Thirteen by killing the Seerseat
-- gb:set_locatable_objective_callback_on_message(
--     "wave_13_in",
--     "wh3_dlc29_endgame_crisis_the_vermintide_objective_00",
--     0,
--     function()
--         local sunit = ga_ai_enemy_wave_13_main.sunits:get_general_sunit();
--         if sunit then
--             local cam_targ = sunit.unit:position();
--             local cam_pos = v_offset_by_bearing(
--                 cam_targ,
--                 get_bearing(cam_targ, bm:camera():position()),    -- horizontal bearing from camera target to current camera position
--                 75,                                               -- distance from camera position to camera target
--                 d_to_r(30)                                        -- vertical bearing from horizon to cam-targ/cam-pos line
--             );
--             return cam_pos, cam_targ;
--         end;
--     end,
--     2
-- );

-- gb:complete_objective_on_message("verminking_defeated", "wh3_dlc29_endgame_crisis_the_vermintide_objective_00");

-----OBJECTIVE 1-----
-- Survive the Council of Thirteen - Each seat on the council sends a force to destroy you
gb:set_objective_on_message("objective_01", "wh3_dlc29_endgame_crisis_the_vermintide_objective_01", 0, 0, 13);
-- gb:complete_objective_on_message("wave_13_defeated", "wh3_dlc29_endgame_crisis_the_vermintide_objective_01");

-----HINTS-----
-- Wave 01 - The Grey Seer Clan represents the 13th seat on behalf of the Horned Rat, his will is interpreted through them
gb:queue_help_on_message("start_wave_01", "wh3_dlc29_endgame_crisis_the_vermintide_hint_01");

-- Wave 02 - Clan Skryre represents the 12th seat, their engineers meld sorcery and science until the two are indivisible, their technology should be feared, beware of their Doomrockets!
gb:queue_help_on_message("start_wave_02", "wh3_dlc29_endgame_crisis_the_vermintide_hint_02");

-- Wave 03 - Clan Moulder represents the 11th seat, these rats have been thown in to the vats and pumped full of far too many mutagens to the point of violent and dangerous instability
gb:queue_help_on_message("start_wave_03", "wh3_dlc29_endgame_crisis_the_vermintide_hint_03");

-- Wave 04 - Clan Pestilens represents the 10th seat, these wretched creatures have wholly embraced the diseased aspect of their horned god, spreading their pestilence far and wide
gb:queue_help_on_message("start_wave_04", "wh3_dlc29_endgame_crisis_the_vermintide_hint_04");

-- Wave 05 - Clan Eshin represents the 9th seat, it would be wise to watch your back as they specialise in the deadly and secretive arts of stealth, murder, poison and assassination
gb:queue_help_on_message("start_wave_05", "wh3_dlc29_endgame_crisis_the_vermintide_hint_05");

-- Wave 06 - Clan Skab represents the 8th seat, they once came to an agreement with the Tomb Kings, acquiring dark magics that they still wield to this day to use against their enemies
gb:queue_help_on_message("start_wave_06", "wh3_dlc29_endgame_crisis_the_vermintide_hint_06");

-- Wave 07 - Clan Morbidus represents the 7th seat, they are known for spreading multiple contagions through plague-ridden rat and beast swarms, dripping with disease
gb:queue_help_on_message("start_wave_07", "wh3_dlc29_endgame_crisis_the_vermintide_hint_07");

-- Wave 08 - Clan Krizzor represents the 6th seat, they found that Skavenslaves dipped in pig's blood made irresistible bait for trapping the foul creatures roaming the darklands
gb:queue_help_on_message("start_wave_08", "wh3_dlc29_endgame_crisis_the_vermintide_hint_08");

-- Wave 09 - Clan Skurvy represents the 5th seat, they may be mangy cutthroats but they control the largest of all the Skaven Clanfleets and churn through their enslaved and short-lived crew
gb:queue_help_on_message("start_wave_09", "wh3_dlc29_endgame_crisis_the_vermintide_hint_09");

-- Wave 10 - Paskrit the Vast belongs to no clan but represents the 4th seat, he is a particularly obese Skaven who favours fighting alongside the larger beasts in battle
gb:queue_help_on_message("start_wave_10", "wh3_dlc29_endgame_crisis_the_vermintide_hint_10");

-- Wave 11 - Clan Rictus represents the 3rd seat, they came in to a great deal of wealth from their inexhaustible supply of slaves and the use of the fearsome Deathvermin in battle
gb:queue_help_on_message("start_wave_11", "wh3_dlc29_endgame_crisis_the_vermintide_hint_11");

-- Wave 12 - Clan Mors represents the 2nd seat, as one of the most powerful of the Warlord Clans who are uncharacteristically united and loyal for Skaven, they flaunt their united strength as a reminder of the clans power
gb:queue_help_on_message("start_wave_12", "wh3_dlc29_endgame_crisis_the_vermintide_hint_12");

-- Wave 13 - Clan Scruten represents the 1st seat, the leaders who will claim dominance over this mortal realm, the Great Ascendancy is upon you, the Vermintide is here!
gb:queue_help_on_message("start_wave_13", "wh3_dlc29_endgame_crisis_the_vermintide_hint_13");

-----------------------------------------------------------------------------
-------------------------------CAMPAIGN CONTEXT-------------------------------
------------------------------------------------------------------------------
local wounded_swarm_threshold = 0.4;

if bm:is_from_campaign() then
local the_vermintide_fb_underempire_threshold_01 = core:svr_load_bool("the_vermintide_fb_underempire_threshold_01")
local the_vermintide_fb_underempire_threshold_02 = core:svr_load_bool("the_vermintide_fb_underempire_threshold_02")
local the_vermintide_fb_underempire_threshold_03 = core:svr_load_bool("the_vermintide_fb_underempire_threshold_03")
local the_vermintide_fb_underempire_threshold_04 = core:svr_load_bool("the_vermintide_fb_underempire_threshold_04")
local the_vermintide_fb_underempire_threshold_05 = core:svr_load_bool("the_vermintide_fb_underempire_threshold_05")

function set_under_empire_threshold_01_skaven_swarm()
	if the_vermintide_fb_underempire_threshold_01 == true then
		wounded_swarm_threshold = 0.4;

		bm:out("----------Using Under-Empire Threshold 01 - 0-19 under-empires");
	elseif the_vermintide_fb_underempire_threshold_01 == false then
		bm:out("----------Not using Under-Empire Threshold 01");
	else
		bm:out("----------Under-Empire Threshold 01 is broken, using default values... ".. tostring(the_vermintide_fb_underempire_threshold_01));
	end
end

function set_under_empire_threshold_02_skaven_swarm()
	if the_vermintide_fb_underempire_threshold_02 == true then
		wounded_swarm_threshold = 0.35;

		bm:out("----------Using Under-Empire Threshold 02 - 20-29 under-empires");
	elseif the_vermintide_fb_underempire_threshold_02 == false then
		bm:out("----------Not using Under-Empire Threshold 02");
	else
		bm:out("----------Under-Empire Threshold 02 is broken, using default values... ".. tostring(the_vermintide_fb_underempire_threshold_02));
	end
end

function set_under_empire_threshold_03_skaven_swarm()
	if the_vermintide_fb_underempire_threshold_03 == true then
		wounded_swarm_threshold = 0.3;

		bm:out("----------Using Under-Empire Threshold 03 - 30-39 under-empires");
	elseif the_vermintide_fb_underempire_threshold_03 == false then
		bm:out("----------Not using Under-Empire Threshold 03");
	else
		bm:out("----------Under-Empire Threshold 03 is broken, using default values... ".. tostring(the_vermintide_fb_underempire_threshold_03));
	end
end

function set_under_empire_threshold_04_skaven_swarm()
	if the_vermintide_fb_underempire_threshold_04 == true then
		wounded_swarm_threshold = 0.25;

		bm:out("----------Using Under-Empire Threshold 04 - 40-50 under-empires");
	elseif the_vermintide_fb_underempire_threshold_04 == false then
		bm:out("----------Not using Under-Empire Threshold 04");
	else
		bm:out("----------Under-Empire Threshold 04 is broken, using default values... ".. tostring(the_vermintide_fb_underempire_threshold_04));
	end
end

function set_under_empire_threshold_05_skaven_swarm()
	if the_vermintide_fb_underempire_threshold_05 == true then
		wounded_swarm_threshold = 0.2;

		bm:out("----------Using Under-Empire Threshold 05 - 51+ under-empires");
	elseif the_vermintide_fb_underempire_threshold_05 == false then
		bm:out("----------Not using Under-Empire Threshold 05");
	else
		bm:out("----------Under-Empire Threshold 05 is broken, using default values... ".. tostring(the_vermintide_fb_underempire_threshold_05));
	end
end
end

----------------------------------
----------SPECIAL ORDERS----------
----------------------------------
local council_waves_defeated = 0;

local perpetual = true;
local shattered_only = false;
local permit_rampaging = true;

set_under_empire_threshold_01_skaven_swarm()
set_under_empire_threshold_02_skaven_swarm()
set_under_empire_threshold_03_skaven_swarm()
set_under_empire_threshold_04_skaven_swarm()
set_under_empire_threshold_05_skaven_swarm()

gb:message_on_time_offset("start", 100);
gb:message_on_time_offset("objective_01", 5000);

----------------------------------------------------------------------
--------------WAVE 1 - 13TH SEAT - GREY SEER CLAN ORDERS--------------
----------------------------------------------------------------------
-- 1 - 13th Seat - Grey Seer Clan - Basic Theme -- Mechanic - NA
ga_ai_enemy_wave_01_main:rush_on_message("start");
ga_ai_enemy_wave_01_main:message_on_rout_proportion("wave_01_wounded", wounded_swarm_threshold);
ga_ai_enemy_wave_01_main:message_on_rout_proportion("wave_01_defeated",0.9);
ga_ai_enemy_wave_01_main:message_on_rout_proportion("wave_defeated",0.9);
ga_ai_enemy_wave_01_main:rout_over_time_on_message("wave_01_defeated", 5000);

gb:add_listener(
	"start",
	function()
		ga_ai_enemy_wave_01_main.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
	end
);

gb:message_on_time_offset("start_wave_02", 2500, "wave_01_wounded");

------------------------------------------------------------------------
----------WAVE 2 - 12TH SEAT - IKIT CLAW - CLAN SKRYRE ORDERS-----------
------------------------------------------------------------------------
-- 2 - 12th Seat - Ikit Claw - Clan Skryre - Warlock Theme -- Mechanic - Doom Rockets (wh2_dlc12_army_abilities_warpstorm_doomrocket_upgraded) & Workshop Upgrades & Clanstones (wh2_main_army_abilities_skryre_clanstone)
ga_ai_enemy_wave_02_main:reinforce_on_message("start_wave_02");
ga_ai_enemy_wave_02_main:message_on_any_deployed("wave_02_in");
ga_ai_enemy_wave_02_main:rush_on_message("wave_02_in");
ga_ai_enemy_wave_02_main:message_on_rout_proportion("wave_02_wounded", wounded_swarm_threshold);
ga_ai_enemy_wave_02_main:message_on_rout_proportion("wave_02_defeated",0.9);
ga_ai_enemy_wave_02_main:message_on_rout_proportion("wave_defeated",0.9);
ga_ai_enemy_wave_02_main:rout_over_time_on_message("wave_02_defeated", 5000);

gb:add_listener(
	"start_wave_02",
	function()
		ga_ai_enemy_wave_02_main.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
	end
);

gb:message_on_time_offset("start_wave_03", 2500, "wave_02_wounded");

-----------------------------------------------------------------------------------------
--------------WAVE 3 - 11TH SEAT - THROTT THE UNCLEAN - CLAN MOULDER ORDERS--------------
-----------------------------------------------------------------------------------------
-- 3 - 11th Seat - Thrott the Unclean - Clan Moulder - Packlord Theme -- Mechanic - Mutated Augments & Clanstones (wh2_main_army_abilities_moulder_clanstone)
ga_ai_enemy_wave_03_main:reinforce_on_message("start_wave_03");
ga_ai_enemy_wave_03_main:message_on_any_deployed("wave_03_in");
ga_ai_enemy_wave_03_main:rush_on_message("wave_03_in");
ga_ai_enemy_wave_03_main:message_on_rout_proportion("wave_03_wounded", wounded_swarm_threshold);
ga_ai_enemy_wave_03_main:message_on_rout_proportion("wave_03_defeated",0.9);
ga_ai_enemy_wave_03_main:message_on_rout_proportion("wave_defeated",0.9);
ga_ai_enemy_wave_03_main:rout_over_time_on_message("wave_03_defeated", 5000);

gb:add_listener(
	"start_wave_03",
	function()
		ga_ai_enemy_wave_03_main.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
	end
);

gb:message_on_time_offset("start_wave_04", 2500, "wave_03_wounded");

------------------------------------------------------------------------------------
--------------WAVE 4 - 10TH SEAT - LORD SKROLK - CLAN PESTILENS ORDERS--------------
------------------------------------------------------------------------------------
-- 4 - 10th Seat - Lord Skrolk - Clan Pestilens - Plague Theme -- Mechanic - Pusbag Swarms & Clanstones (wh2_main_army_abilities_pestilens_clanstone)
ga_ai_enemy_wave_04_main:reinforce_on_message("start_wave_04");
ga_ai_enemy_wave_04_main:message_on_any_deployed("wave_04_in");
ga_ai_enemy_wave_04_main:rush_on_message("wave_04_in");
ga_ai_enemy_wave_04_main:message_on_rout_proportion("wave_04_wounded", wounded_swarm_threshold);
ga_ai_enemy_wave_04_main:message_on_rout_proportion("wave_04_defeated",0.9);
ga_ai_enemy_wave_04_main:message_on_rout_proportion("wave_defeated",0.9);
ga_ai_enemy_wave_04_main:rout_over_time_on_message("wave_04_defeated", 5000);

gb:add_listener(
	"start_wave_04",
	function()
		ga_ai_enemy_wave_04_main.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
	end
);

gb:message_on_time_offset("start_wave_05", 2500, "wave_04_wounded");

-- Pusbag Swarms
gb:message_on_time_offset("start_pusbag_swarms", 10000, "start_wave_04");

ga_ai_enemy_wave_04_chaff:deploy_at_random_intervals_on_message(
	"start_pusbag_swarms", 		-- message
	2, 							-- min units
	2, 							-- max units
	18000, 						-- min period
	18000, 						-- max period
	"wave_04_defeated", 		-- cancel message
	true,						-- spawn first wave immediately
	true,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

ga_ai_enemy_wave_04_chaff:message_on_any_deployed("wave_04_chaff_in");
ga_ai_enemy_wave_04_chaff:rush_on_message("wave_04_chaff_in");
ga_ai_enemy_wave_04_chaff:rout_over_time_on_message("wave_04_defeated", 5000);

gb:add_listener(
	"wave_04_chaff_in",
	function()
		ga_ai_enemy_wave_04_chaff.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
	end
);

--------------------------------------------------------------------------------------
--------------WAVE 5 - 9TH SEAT - DEATHMASTER SNIKCH - CLAN ESHIN ORDERS--------------
--------------------------------------------------------------------------------------
-- 5 - 9th Seat - Deathmaster Snikch - Clan Eshin - Assassin Theme -- Mechanic - Flanker & AP & Clanstones (wh2_main_army_abilities_eshin_clanstone)
ga_ai_enemy_wave_05_main:reinforce_on_message("start_wave_05");
ga_ai_enemy_wave_05_main:message_on_any_deployed("wave_05_in");
ga_ai_enemy_wave_05_main:rush_on_message("wave_05_in");
ga_ai_enemy_wave_05_main:message_on_rout_proportion("wave_05_wounded", wounded_swarm_threshold);
ga_ai_enemy_wave_05_main:message_on_rout_proportion("wave_05_defeated",0.9);
ga_ai_enemy_wave_05_main:message_on_rout_proportion("wave_defeated",0.9);
ga_ai_enemy_wave_05_main:rout_over_time_on_message("wave_05_defeated", 5000);

gb:add_listener(
	"start_wave_05",
	function()
		ga_ai_enemy_wave_05_main.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
	end
);

gb:message_on_time_offset("start_wave_06", 2500, "wave_05_wounded");

------------------------------------------------------------------------------------------
--------------WAVE 6 - 8TH SEAT - LORD GRIZNEKT MANCARVER - CLAN SKAB ORDERS--------------
------------------------------------------------------------------------------------------
-- 6 - 8th Seat - Lord Griznekt Mancarver - Clan Skab - Warrior Theme -- Mechanic - Tomb Kings Units & Dark Magic
ga_ai_enemy_wave_06_main:reinforce_on_message("start_wave_06");
ga_ai_enemy_wave_06_main:message_on_any_deployed("wave_06_in");
ga_ai_enemy_wave_06_main:rush_on_message("wave_06_in");
ga_ai_enemy_wave_06_main:message_on_rout_proportion("wave_06_wounded", wounded_swarm_threshold);
ga_ai_enemy_wave_06_main:message_on_rout_proportion("wave_06_defeated",0.9);
ga_ai_enemy_wave_06_main:message_on_rout_proportion("wave_defeated",0.9);
ga_ai_enemy_wave_06_main:rout_over_time_on_message("wave_06_defeated", 5000);

gb:add_listener(
	"start_wave_06",
	function()
		ga_ai_enemy_wave_06_main.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
	end
);

gb:message_on_time_offset("start_wave_07", 2500, "wave_06_wounded");

------------------------------------------------------------------------------------------
--------------WAVE 7 - 7TH SEAT - ARCH-PONTIFEX SITCH - CLAN MORBIDUS ORDERS--------------
------------------------------------------------------------------------------------------
-- 7 - 7th Seat - Arch-Pontifex Sitch - Clan Morbidus - Plague Creatures/Packlord Theme -- Mechanic - Cauldrons & Bound Blight Boils
ga_ai_enemy_wave_07_main:reinforce_on_message("start_wave_07");
ga_ai_enemy_wave_07_main:message_on_any_deployed("wave_07_in");
ga_ai_enemy_wave_07_main:rush_on_message("wave_07_in");
ga_ai_enemy_wave_07_main:message_on_rout_proportion("wave_07_wounded", wounded_swarm_threshold);
ga_ai_enemy_wave_07_main:message_on_rout_proportion("wave_07_defeated",0.9);
ga_ai_enemy_wave_07_main:message_on_rout_proportion("wave_defeated",0.9);
ga_ai_enemy_wave_07_main:rout_over_time_on_message("wave_07_defeated", 5000);

gb:add_listener(
	"start_wave_07",
	function()
		ga_ai_enemy_wave_07_main.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
	end
);

gb:message_on_time_offset("start_wave_08", 2500, "wave_07_wounded");

---------------------------------------------------------------------------------------------------
--------------WAVE 8 - 6TH SEAT - ARCH-BRUTELORD HESH VRAKSPINE - CLAN KRIZZOR ORDERS--------------
---------------------------------------------------------------------------------------------------
-- 8 - 6th Seat -  Arch-Brutelord Hesh Vrakspine - Clan Krizzor - Dark Lands Creature/Packlord Theme -- Mechanic - NA
ga_ai_enemy_wave_08_main:reinforce_on_message("start_wave_08");
ga_ai_enemy_wave_08_main:message_on_any_deployed("wave_08_in");
ga_ai_enemy_wave_08_main:rush_on_message("wave_08_in");
ga_ai_enemy_wave_08_main:message_on_rout_proportion("wave_08_wounded", wounded_swarm_threshold);
ga_ai_enemy_wave_08_main:message_on_rout_proportion("wave_08_defeated",0.9);
ga_ai_enemy_wave_08_main:message_on_rout_proportion("wave_defeated",0.9);
ga_ai_enemy_wave_08_main:rout_over_time_on_message("wave_08_defeated", 5000);

gb:add_listener(
	"start_wave_08",
	function()
		ga_ai_enemy_wave_08_main.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
	end
);

gb:message_on_time_offset("start_wave_09", 2500, "wave_08_wounded");

------------------------------------------------------------------------------------------------
--------------WAVE 9 - 5TH SEAT - WARLORD VRISK IRONSCRATCH - CLAN SKURVY - ORDERS--------------
------------------------------------------------------------------------------------------------
-- 9 - 5th Seat - Warlord Vrisk Ironscratch - Clan Skurvy - Slaves/Assassin/Warlock Theme -- Mechanic - Slave Swarms & Naval Bombardment
ga_ai_enemy_wave_09_main:reinforce_on_message("start_wave_09");
ga_ai_enemy_wave_09_main:message_on_any_deployed("wave_09_in");
ga_ai_enemy_wave_09_main:rush_on_message("wave_09_in");
ga_ai_enemy_wave_09_main:message_on_rout_proportion("wave_09_wounded", wounded_swarm_threshold);
ga_ai_enemy_wave_09_main:message_on_rout_proportion("wave_09_defeated",0.9);
ga_ai_enemy_wave_09_main:message_on_rout_proportion("wave_defeated",0.9);
ga_ai_enemy_wave_09_main:rout_over_time_on_message("wave_09_defeated", 5000);

gb:add_listener(
	"start_wave_09",
	function()
		ga_ai_enemy_wave_09_main.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
	end
);

gb:message_on_time_offset("start_wave_10", 2500, "wave_09_wounded");

-- Pirate Slave Swarms
gb:message_on_time_offset("start_pirate_swarms", 10000, "start_wave_09");

ga_ai_enemy_wave_09_chaff:deploy_at_random_intervals_on_message(
	"start_pirate_swarms", 		-- message
	2, 							-- min units
	2, 							-- max units
	18000, 						-- min period
	18000, 						-- max period
	"wave_09_defeated", 		-- cancel message
	true,						-- spawn first wave immediately
	true,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

ga_ai_enemy_wave_09_chaff:message_on_any_deployed("wave_09_chaff_in");
ga_ai_enemy_wave_09_chaff:rush_on_message("wave_09_chaff_in");
ga_ai_enemy_wave_09_chaff:rout_over_time_on_message("wave_09_defeated", 5000);

gb:add_listener(
	"wave_09_chaff_in",
	function()
		ga_ai_enemy_wave_09_chaff.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
	end
);

----------------------------------------------------------------------------------
--------------WAVE 10 - 4TH SEAT - PASKRIT THE VAST - NO CLAN ORDERS--------------
----------------------------------------------------------------------------------
-- 10 - 4th Seat - Paskrit the Vast - No Clan - Monster/Warrior Theme -- Mechanic - Fat Rat
ga_ai_enemy_wave_10_main:reinforce_on_message("start_wave_10");
ga_ai_enemy_wave_10_main:message_on_any_deployed("wave_10_in");
ga_ai_enemy_wave_10_main:rush_on_message("wave_10_in");
ga_ai_enemy_wave_10_main:message_on_rout_proportion("wave_10_wounded", wounded_swarm_threshold);
ga_ai_enemy_wave_10_main:message_on_rout_proportion("wave_10_defeated",0.9);
ga_ai_enemy_wave_10_main:message_on_rout_proportion("wave_defeated",0.9);
ga_ai_enemy_wave_10_main:rout_over_time_on_message("wave_10_defeated", 5000);

gb:add_listener(
	"start_wave_10",
	function()
		ga_ai_enemy_wave_10_main.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
	end
);

gb:message_on_time_offset("start_wave_11", 2500, "wave_10_wounded");

---------------------------------------------------------------------------------------
--------------WAVE 11 - 3RD SEAT - TRETCH CRAVENTAIL - CLAN RICTUS ORDERS--------------
---------------------------------------------------------------------------------------
-- 11 - 3rd Seat - Tretch Craventail - Clan Rictus - Night Goblins/Slaves/Stormvermin Theme -- Mechanic - Deathvermin & Slave Swarms & Clanstones (wh2_dlc09_army_abilities_rictus_clanstone)
ga_ai_enemy_wave_11_main:reinforce_on_message("start_wave_11");
ga_ai_enemy_wave_11_main:message_on_any_deployed("wave_11_in");
ga_ai_enemy_wave_11_main:rush_on_message("wave_11_in");
ga_ai_enemy_wave_11_main:message_on_rout_proportion("wave_11_wounded", wounded_swarm_threshold);
ga_ai_enemy_wave_11_main:message_on_rout_proportion("wave_11_defeated",0.9);
ga_ai_enemy_wave_11_main:message_on_rout_proportion("wave_defeated",0.9);
ga_ai_enemy_wave_11_main:rout_over_time_on_message("wave_11_defeated", 5000);

gb:add_listener(
	"start_wave_11",
	function()
		ga_ai_enemy_wave_11_main.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
	end
);

gb:message_on_time_offset("start_wave_12", 2500, "wave_11_wounded");

-- Slave Swarms
gb:message_on_time_offset("start_slave_swarms", 10000, "start_wave_11");

ga_ai_enemy_wave_11_chaff:deploy_at_random_intervals_on_message(
	"start_slave_swarms", 		-- message
	4, 							-- min units
	4, 							-- max units
	12000, 						-- min period
	12000, 						-- max period
	"wave_11_defeated", 		-- cancel message
	true,						-- spawn first wave immediately
	true,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

ga_ai_enemy_wave_11_chaff:message_on_any_deployed("wave_11_chaff_in");
ga_ai_enemy_wave_11_chaff:rush_on_message("wave_11_chaff_in");
ga_ai_enemy_wave_11_chaff:rout_over_time_on_message("wave_11_defeated", 5000);

gb:add_listener(
	"wave_11_chaff_in",
	function()
		ga_ai_enemy_wave_11_chaff.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
	end
);

-----------------------------------------------------------------------------------
--------------WAVE 12 - 2ND SEAT - QUEEK HEADTAKER - CLAN MORS ORDERS--------------
-----------------------------------------------------------------------------------
-- 12 - 2nd Seat - Queek Headtaker - Clan Mors - Warrior Theme -- Mechanic - Warpweed (Infantry Strength Buff) & Clanstones (wh2_main_army_abilities_mors_clanstone)
ga_ai_enemy_wave_12_main:reinforce_on_message("start_wave_12");
ga_ai_enemy_wave_12_main:message_on_any_deployed("wave_12_in");
ga_ai_enemy_wave_12_main:rush_on_message("wave_12_in");
ga_ai_enemy_wave_12_main:message_on_rout_proportion("wave_12_wounded", wounded_swarm_threshold);
ga_ai_enemy_wave_12_main:message_on_rout_proportion("wave_12_defeated",0.9);
ga_ai_enemy_wave_12_main:message_on_rout_proportion("wave_defeated",0.9);
ga_ai_enemy_wave_12_main:rout_over_time_on_message("wave_12_defeated", 5000);

gb:add_listener(
	"start_wave_12",
	function()
		ga_ai_enemy_wave_12_main.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
	end
);

gb:message_on_time_offset("start_wave_13", 2500, "wave_12_wounded");

--------------------------------------------------------------------------------------------------
--------------WAVE 13 - 1ST SEAT - SKREECH VERMINKING/THANQUOL - CLAN SCRUTEN ORDERS--------------
--------------------------------------------------------------------------------------------------
-- 13 - 1st Seat - Skreech Verminking/Thanquol - Clan Scruten - ??? Theme -- Mechanic - Clanstones (wh3_dlc29_army_abilities_scruten_clanstone)
ga_ai_enemy_wave_13_main:add_winds_of_magic_on_message("start_wave_13", 50);
ga_ai_enemy_wave_13_main:reinforce_on_message("start_wave_13");
-- ga_ai_enemy_wave_13_main:message_on_commander_dead_or_routing("verminking_defeated");
ga_ai_enemy_wave_13_main:get_army():suppress_reinforcement_adc(1);
ga_ai_enemy_wave_13_main:message_on_any_deployed("wave_13_in");
ga_ai_enemy_wave_13_main:rush_on_message("wave_13_in");
ga_ai_enemy_wave_13_main:message_on_rout_proportion("wave_13_defeated",0.95);
ga_ai_enemy_wave_13_main:message_on_rout_proportion("wave_defeated",0.9);
ga_ai_enemy_wave_13_main:rout_over_time_on_message("wave_13_defeated", 5000);

-- gb:add_listener(
-- 	"start_wave_13",
-- 	function()
-- 		ga_ai_enemy_wave_13_main.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);

-- 		skreech_character:add_ping_icon(15);
-- 	end
-- );

-- gb:add_listener(
-- 	"start_wave_13",
-- 	function()
-- 		bm:repeat_callback(
-- 			function()
-- 				if ga_ai_enemy_wave_13_main.sunits:item(2).unit:unary_hitpoints() <= 0 then
-- 					sm:trigger_message("verminking_defeated")
-- 				end
-- 			end,
-- 			1000,
-- 			"verminking_dead"
-- 		)
-- 	end,
-- 	true
-- )

-- gb:add_listener(
--     "verminking_defeated",
-- 	function()
-- 		bm:remove_callback("verminking_dead")
--     end,
-- 	true
-- )

------------------------------------------------
----------COUNCIL OF THIRTEEN MECHANIC----------
------------------------------------------------
-- All Council Waves
gb:add_listener(
	"start",
	function()
    bm:repeat_callback(
        function()
            if council_waves_defeated == 1 then
				bm:set_objective("wh3_dlc29_endgame_crisis_the_vermintide_objective_01", 1, 13);
            end

            if council_waves_defeated == 2 then
				bm:set_objective("wh3_dlc29_endgame_crisis_the_vermintide_objective_01", 2, 13);
            end

            if council_waves_defeated == 3 then
				bm:set_objective("wh3_dlc29_endgame_crisis_the_vermintide_objective_01", 3, 13);
            end

            if council_waves_defeated == 4 then
				bm:set_objective("wh3_dlc29_endgame_crisis_the_vermintide_objective_01", 4, 13);
            end

			if council_waves_defeated == 5 then
				bm:set_objective("wh3_dlc29_endgame_crisis_the_vermintide_objective_01", 5, 13);
            end

            if council_waves_defeated == 6 then
				bm:set_objective("wh3_dlc29_endgame_crisis_the_vermintide_objective_01", 6, 13);
            end

			 if council_waves_defeated == 7 then
				bm:set_objective("wh3_dlc29_endgame_crisis_the_vermintide_objective_01", 7, 13);
            end

            if council_waves_defeated == 8 then
				bm:set_objective("wh3_dlc29_endgame_crisis_the_vermintide_objective_01", 8, 13);
            end

			if council_waves_defeated == 9 then
				bm:set_objective("wh3_dlc29_endgame_crisis_the_vermintide_objective_01", 9, 13);
            end

			if council_waves_defeated == 10 then
				bm:set_objective("wh3_dlc29_endgame_crisis_the_vermintide_objective_01", 10, 13);
            end

            if council_waves_defeated == 11 then
				bm:set_objective("wh3_dlc29_endgame_crisis_the_vermintide_objective_01", 11, 13);
            end

			 if council_waves_defeated == 12 then
				bm:set_objective("wh3_dlc29_endgame_crisis_the_vermintide_objective_01", 12, 13);
            end

            if council_waves_defeated == 13 then
				bm:complete_objective("wh3_dlc29_endgame_crisis_the_vermintide_objective_01");
            end
         end,
        1000,
        "council_of_thirteen_defeated"
    )
	end,
	true
)

-- Waves Counter
gb:add_listener(
    "wave_defeated",
	function()
		council_waves_defeated = council_waves_defeated + 1
		bm:out("Council Waves Killed: " .. tostring(council_waves_defeated));
    end,
	true
)

----------------------
-------END GAME-------
----------------------
gb:message_on_all_messages_received("council_of_thirteen_defeated","wave_01_defeated","wave_02_defeated","wave_03_defeated","wave_04_defeated","wave_05_defeated","wave_06_defeated","wave_07_defeated","wave_08_defeated","wave_09_defeated","wave_10_defeated","wave_11_defeated","wave_12_defeated","wave_13_defeated");

ga_player_01:force_victory_on_message("council_of_thirteen_defeated", 5000);