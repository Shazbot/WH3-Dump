

gb = generated_battle:new(
	true,                                      		    -- screen starts black
	true,                                      		-- prevent deployment for player
	true,                                      		    -- prevent deployment for ai
	function() end_deployment_phase() end,          	-- intro cutscene function
	false                                      			-- debug mode
);

--preload stuttering fix
intro_cinematic_file = "script/battle/quest_battles/_cutscene/managers/heart_first_01.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);

-------------------------------------------------------------------------------------------------
---------------------------------------- ARMY ABILITIES -----------------------------------------
-------------------------------------------------------------------------------------------------
local army_abilities = {
	"wh2_dlc17_army_abilities_chaos_spawn_summon_qb_scripted",
	"wh2_dlc17_army_abilities_cygor_summon_qb_scripted",
	"wh2_dlc17_army_abilities_ghorgon_summon_qb_scripted"
};

function show_army_abilities(value)
	local army_ability_parent = get_army_ability_parent();
	
	if army_ability_parent then
		for i = 1, #army_abilities do
			local uic_holder = find_uicomponent(army_ability_parent, "button_holder_" .. army_abilities[i]);
			if uic_holder then
				uic_holder:SetVisible(value);
			end;
		end;
	end;
end;

function get_army_ability_parent()
	return find_uicomponent(core:get_ui_root(), "army_ability_parent");
end;

show_army_abilities(false);

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------
bm:out("## ARMY SETUP INITIALISED ##");

--Friendlies
	--Player
	ga_taurox = gb:get_army(gb:get_player_alliance_num(), 1, "");

	-- Allied Great Brays
	ga_ally_great_bray_01 = gb:get_army(gb:get_player_alliance_num(), "ally_great_bray_01");
	ga_ally_great_bray_02 = gb:get_army(gb:get_player_alliance_num(), "ally_great_bray_02");

	ga_ally_prison_guards_01 = gb:get_army(gb:get_player_alliance_num(), "ally_prison_guards_01");
	ga_ally_prison_guards_02 = gb:get_army(gb:get_player_alliance_num(), "ally_prison_guards_02");

--Enemies
	--Morghur--
	ga_enemy_army_morghur_main = gb:get_army(gb:get_non_player_alliance_num(), "enemy_army_morghur_main");
	ga_enemy_army_morghur_fast_beasts = gb:get_army(gb:get_non_player_alliance_num(), "enemy_army_morghur_fast_beasts");
	ga_enemy_army_morghur_patrol_pigs = gb:get_army(gb:get_non_player_alliance_num(), "enemy_army_morghur_patrol_pigs");

	--Prisoners--
	ga_reinforcement_army_prisoners_01 = gb:get_army(gb:get_non_player_alliance_num(), "reinforcement_army_prisoners_01");
	ga_reinforcement_army_prisoners_02 = gb:get_army(gb:get_non_player_alliance_num(), "reinforcement_army_prisoners_02");
	ga_reinforcement_army_prisoners_01_general = gb:get_army(gb:get_non_player_alliance_num(), "reinforcement_army_prisoners_01_general");

	--Oxyotl--
	ga_enemy_army_oxyotl = gb:get_army(gb:get_non_player_alliance_num(), "enemy_army_oxyotl");
	ga_enemy_army_oxyotl_main = gb:get_army(gb:get_non_player_alliance_num(), "enemy_army_oxyotl_main");
	ga_enemy_army_krox = gb:get_army(gb:get_non_player_alliance_num(), "enemy_army_lizardmen");

bm:out("## ARMY SETUP COMPLETE ##");

function battle_start_teleport_units()
	--Move Taurox for cutscene
		ga_taurox.sunits:item(1).uc:teleport_to_location(v(-208.714,-199.872), 12, 40);

	-- Morghur's Forces

	-- Morghur Main Army
		-- Morghur and Bray Wyatt
		ga_enemy_army_morghur_main.sunits:item(1).uc:teleport_to_location(v(-6.5,410.706), 180, 40);
		ga_enemy_army_morghur_main.sunits:item(2).uc:teleport_to_location(v(-31.0868,477.225), 92, 40);
		
		-- Centigors
		ga_enemy_army_morghur_main.sunits:item(3).uc:teleport_to_location(v(-118.381,400.559), 240, 40);
		ga_enemy_army_morghur_main.sunits:item(4).uc:teleport_to_location(v(75.8989,390.443), 120, 40);

		-- Centigors Axes
		ga_enemy_army_morghur_main.sunits:item(5).uc:teleport_to_location(v(-65.4745,367.622), 180, 40);
		ga_enemy_army_morghur_main.sunits:item(6).uc:teleport_to_location(v(-23.1316,366.846), 180, 40);

		-- Jabberslythe
		ga_enemy_army_morghur_main.sunits:item(7).uc:teleport_to_location(v(-27.4437,489.012), 180, 40);

		-- Spawn
		ga_enemy_army_morghur_main.sunits:item(8).uc:teleport_to_location(v(19.2113,366.071), 190, 40);
		ga_enemy_army_morghur_main.sunits:item(9).uc:teleport_to_location(v(-89.4328,438.723), 240, 41);
		ga_enemy_army_morghur_main.sunits:item(10).uc:teleport_to_location(v(-19.3655,415.347), 180, 41);
		ga_enemy_army_morghur_main.sunits:item(11).uc:teleport_to_location(v(52.6715,431.435), 120, 41);

		-- Giant
		ga_enemy_army_morghur_main.sunits:item(12).uc:teleport_to_location(v(-18.5203,446.497), 180, 40);

		-- Cygors
		ga_enemy_army_morghur_main.sunits:item(13).uc:teleport_to_location(v(-40.0683,446.677), 180, 40);
		ga_enemy_army_morghur_main.sunits:item(14).uc:teleport_to_location(v(2.41206,444.285), 180, 40);

	-- Morghur Fast Beasts (Warhounds and Harpies)
		-- Warhounds
		ga_enemy_army_morghur_fast_beasts.sunits:item(1).uc:teleport_to_location(v(-386.576,115.607), 131, 40);
		ga_enemy_army_morghur_fast_beasts.sunits:item(2).uc:teleport_to_location(v(116.622,-112.292), 263, 40);

		-- Harpies
		ga_enemy_army_morghur_fast_beasts.sunits:item(3).uc:teleport_to_location(v(-52.8892,420.991), 180, 41);
		ga_enemy_army_morghur_fast_beasts.sunits:item(4).uc:teleport_to_location(v(17.3037,421.056), 180, 41);

	-- Morghur Patrol Pigs (Razorgors)
		ga_enemy_army_morghur_patrol_pigs.sunits:item(1).uc:teleport_to_location(v(152.662,161.796), 270, 40);
		ga_enemy_army_morghur_patrol_pigs.sunits:item(2).uc:teleport_to_location(v(-299.575,146.627), 90, 40);

		ga_enemy_army_morghur_main:set_visible_to_all(true);
		ga_enemy_army_morghur_fast_beasts:set_visible_to_all(true);
		ga_enemy_army_morghur_patrol_pigs:set_visible_to_all(true);
		ga_reinforcement_army_prisoners_01:set_visible_to_all(true);
		ga_reinforcement_army_prisoners_02:set_visible_to_all(true);
		ga_enemy_army_oxyotl:set_visible_to_all(true);
		ga_enemy_army_oxyotl_main:set_visible_to_all(true);
		ga_enemy_army_krox:set_visible_to_all(true);

		ga_reinforcement_army_prisoners_01.sunits:set_stat_attribute("unbreakable", true);
		ga_reinforcement_army_prisoners_02.sunits:set_stat_attribute("unbreakable", true);

		start_patrol_1()
end;