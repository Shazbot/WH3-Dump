cam = bm:camera();
alliances = bm:alliances();

cam:fade(false, 0.5)


--
-- Player setup
--

alliance_player = alliances:item(bm:get_player_alliance_num());
army_player_01 = alliance_player:armies():item(1);
-- army_player_02 = alliance_player:armies():item(2);





sunits_player_all = scriptunits_from_army("player_all", army_player_01);
sunits_player_all:out();
sunits_player_ogres = sunits_player_all:filter("player_ogres", function(sunit) return sunit.unit:type() == "wh2_main_skv_mon_rat_ogres" end);
sunits_player_non_ogres = sunits_player_all:filter("player_not_cav", function(sunit) return sunit.unit:type() ~= "wh2_main_skv_mon_rat_ogres" end);
sunits_player_inf = sunits_player_all:filter("player_inf", function(sunit) return sunit.unit:type() == "wh2_main_skv_inf_clanrat_spearmen_1" end);
sunits_player_ranged = sunits_player_all:filter("player_ranged", function(sunit) return sunit.unit:type() == "wh2_main_skv_inf_skavenslave_slingers_0" end);
sunits_player_general = sunits_player_all:filter("player_general", function(sunit) return sunit.unit:type() == "wh2_main_skv_cha_queek_headtaker" end);


-- position player ogres
if sunits_player_ogres:count() == 2 then
	sunits_player_ogres:item(1).uc:teleport_to_location(v(187.8, -25.6), r_to_d(-1.64), 21.5);
	sunits_player_ogres:item(2).uc:teleport_to_location(v(186.1, 0.32), r_to_d(-1.64), 21.5);
else
	script_error("WARNING: player doesn't have two ogre units, has [" .. sunits_player_ogres:count() .. "] instead, how can this be? Not teleporting them");
	sunits_player_ogres:out();
end;


-- position player infantry
if sunits_player_inf:count() == 3 then
	sunits_player_inf:item(1).uc:teleport_to_location(v(142.3, -61.5), r_to_d(-1.57), 31.7);
	sunits_player_inf:item(2).uc:teleport_to_location(v(142.4, -27.8), r_to_d(-1.57), 31.7);
	sunits_player_inf:item(3).uc:teleport_to_location(v(142.4, 5.1), r_to_d(-1.57), 30.1);
else
	script_error("WARNING: player doesn't have three infantry units, has [" .. sunits_player_inf:count() .. "] instead, how can this be? Not teleporting them");
	sunits_player_inf:out();
end;


-- position player ranged
if sunits_player_ranged:count() == 2 then
	sunits_player_ranged:item(1).uc:teleport_to_location(v(142.4, 37.0), r_to_d(-1.57), 29.7);
	sunits_player_ranged:item(2).uc:teleport_to_location(v(142.4, 68.7), r_to_d(-1.57), 29.7);
else
	script_error("WARNING: player doesn't have two ranged units, has [" .. sunits_player_ranged:count() .. "] instead, how can this be? Not teleporting them");
	sunits_player_ranged:out();
end;


-- position player general
if sunits_player_general:count() == 1 then
	sunits_player_general:item(1).uc:teleport_to_location(v(168.8, 1.9), r_to_d(-1.57), 1.4);
else
	script_error("WARNING: couldn't find the player's general to teleport, how can this be?");
	sunits_player_general:out();
end;





area_hill_deployment = convex_area:new({
	v(110, 65),
	v(110, 240),
	v(210, 240),
	v(210, 65)
});

--
-- Enemy setup
--

alliance_enemy = alliances:item(bm:get_non_player_alliance_num()); 
army_enemy_01 = alliance_enemy:armies():item(1);
sunits_enemy_all = scriptunits_from_army("enemy_all", army_enemy_01);
sunits_enemy_all:out();

sunits_enemy_art = sunits_enemy_all:filter("enemy_art", function(sunit) return sunit.unit:unit_class() == "art_fld" end);

-- get the first melee unit and add it as a bodyguard for the artillery
for i = 1, sunits_enemy_all:count() do
	local current_sunit = sunits_enemy_all:item(i);
	if current_sunit.unit:is_infantry() and not current_sunit.unit:is_commanding_unit() then
		sunits_enemy_art:add_sunits(current_sunit);
		break;
	end;
end;

if sunits_enemy_art:count() ~= 2 then
	script_error("WARNING: sunits_enemy_art should have two units in it, it has [" .. tostring(sunits_enemy_art:count()) .. "] units instead");
end;


sunits_enemy_main = sunits_enemy_all:filter("enemy_main", function(sunit) return not sunits_enemy_art:contains_sunit(sunit) end);
