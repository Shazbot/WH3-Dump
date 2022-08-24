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
sunits_player_cav = sunits_player_all:filter("player_cav", function(sunit) return sunit.unit:is_cavalry() end);
sunits_player_non_cav = sunits_player_all:filter("player_not_cav", function(sunit) return not sunit.unit:is_cavalry() end);

-- position player cav
if sunits_player_cav:count() == 2 then
	sunits_player_cav:item(1).uc:teleport_to_location(v(30.7, 186.3), r_to_d(3.13), 22.4);
	sunits_player_cav:item(2).uc:teleport_to_location(v(6.3, 186.1), r_to_d(3.13), 22.4);
else
	script_error("WARNING: player doesn't have two cavalry units, has [" .. sunits_player_cav:count() .. "] instead, how can this be? Not teleporting them");
	sunits_player_cav:out();
end;



area_hill_deployment = convex_area:new({
	v(-70, 125),
	v(-330, 125),
	v(-330, 300),
	v(-70, 300)
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
