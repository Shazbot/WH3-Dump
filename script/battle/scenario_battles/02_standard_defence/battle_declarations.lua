cam = bm:camera();

bm:suppress_unit_voices(true);

output_uicomponent_on_click();

--
-- Player setup
--

sunits_player_all = bm:get_scriptunits_for_army(1, 1);

sunits_player_spearmen = sunits_player_all:filter(
	"player_spearmen",
	function(sunit)
		return string.find(sunit.unit:type(), "tutorial");
	end
);

sunits_player_non_spearmen = sunits_player_all:filter(
	"player_non_spearmen",
	function(sunit)
		return not string.find(sunit.unit:type(), "tutorial");
	end
);

-- disable skirmish mode on all the player's missile units
sunits_player_missile = sunits_player_all:filter(
	"player_missile",
	function(sunit)
		return sunit.unit:starting_ammo() > 5;
	end
);
sunits_player_missile:change_behaviour_active("skirmish", false);

sunits_player_all:hide_unbreakable_in_ui(true);
sunits_player_all:release_control();



--
-- Enemy setup
--

sunits_enemy_all = bm:get_scriptunits_for_army(2, 1);
sunits_enemy_all:hide_unbreakable_in_ui(true);

sunits_enemy_cavalry = sunits_enemy_all:filter(
	"enemy_cavalry",
	function(sunit)
		return sunit.unit:unit_class() == "cav_mis" and not sunit.unit:is_commanding_unit()
	end,
	true
)
sai_enemy_cavalry = false;
sunits_enemy_cavalry:modify_ammo(0); 				-- strip ammo from cavalry so they engage in melee
sunits_enemy_cavalry:take_control(); 				-- prevent enemy cavalry from re-deploying

sunits_enemy_cavalry_2 = sunits_enemy_cavalry:duplicate("enemy_cavalry_2");

-- enemy foot group contains commander to start with
sunits_enemy_foot = sunits_enemy_all:filter(
	"enemy_foot",
	function(sunit)
		return sunit.unit:is_commanding_unit() or sunit.unit:unit_class() ~= "cav_mis"
	end,
	true
)
sai_enemy_foot = false;
sunits_enemy_foot:take_control()
--
-- UI functions
--

function get_unit_details_button()
	return find_uicomponent(core:get_ui_root(), "hud_battle", "porthole_parent", "button_toggle_infopanel")
end

function show_unit_details_panel(value)
	local uic_button = get_unit_details_button()

	uic_button:SetInteractive(true)
	uic_button:SetVisible(true)

	if value then
		if uic_button:CurrentState() ~= "selected" and uic_button:CurrentState() ~= "selected_hover" then
			uic_button:SimulateLClick()
		end
	else
		if uic_button:CurrentState() == "selected" or uic_button:CurrentState() == "selected_hover" then
			uic_button:SimulateLClick()
		end
	end
end

function get_unit_camera_button()
	return find_uicomponent(core:get_ui_root(), "hud_battle", "porthole_parent", "button_unit_camera")
end

-- cheat function to prematurely end the battle
function end_battle()
	script_error("end_battle() is prematurely ending the battle");

	-- kill 10% of player's troops
	sunits_player_all:kill_proportion(0.1);

	local t = 5000;

	-- kill/rout enemy troops
	sunits_enemy_all:kill_proportion_over_time(1, t);

	bm:callback(function() sunits_enemy_all:morale_behavior_rout() end, t);
end;