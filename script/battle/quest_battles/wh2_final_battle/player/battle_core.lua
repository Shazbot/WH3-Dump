gc:add_element(nil, nil, "wh2_main_qb_final_battle_00", 8000, false, false, false);

if speech[1] then
	gc:add_element(speech[1][1], speech[1][2], "gc_orbit_90_medium_commander_front_close_low_01", 8000, true, false, false);
	gc:add_element(speech[2][1], speech[2][2], "gc_slow_army_pan_front_left_to_front_right_far_high_01", 8000, true, false, false);
	gc:add_element(speech[3][1], speech[3][2], "gc_orbit_ccw_90_medium_commander_front_left_extreme_high_01", 8000, true, false, false);
	gc:add_element(speech[4][1], speech[4][2], "gc_medium_army_pan_back_right_to_back_left_far_high_01", 8000, true, false, false);
	
	if speech[5] then
		gc:add_element(speech[5][1], speech[5][2], "gc_orbit_90_medium_commander_back_left_extreme_high_01", 8000, true, false, false);
	end;
end;

gb:set_cutscene_during_deployment(true);

local sm = get_messager();

-------ARMIES-------
local ai_alliance = gb:get_non_player_alliance_num();

-- initial defence - grey seer clan OR high elves
ga_ai_defence = gb:get_army(ai_alliance, 1);

-- first reinforcing race - high elves OR dark elves OR lizardmen
local race_1_hint = "";
local race_1_objective = "";
local race_1_advice = "";

if gb:get_army(ai_alliance, 2, "def_wave_1") then
	ga_ai_race_1 = gb:get_army(ai_alliance, 2);
	
	ga_ai_race_1_wave_1 = gb:get_army(ai_alliance, 2, "def_wave_1");
	
	ga_ai_race_1_wave_2 = gb:get_army(ai_alliance, 2, "def_wave_2");
	
	race_1_hint = "wh2_main_qb_final_battle_hint_objective_defeat_dark_elves";
	race_1_objective = "wh2_main_qb_final_battle_main_objective_defeat_dark_elves";
	race_1_advice = "wh2.battle.advice.final_battle_mid.004";
elseif gb:get_army(ai_alliance, 2, "hef_wave_1") then
	ga_ai_race_1 = gb:get_army(ai_alliance, 2);
	
	ga_ai_race_1_wave_1 = gb:get_army(ai_alliance, 2, "hef_wave_1");
	
	ga_ai_race_1_wave_2 = gb:get_army(ai_alliance, 2, "hef_wave_2");
	
	race_1_hint = "wh2_main_qb_final_battle_hint_objective_defeat_high_elves";
	race_1_objective = "wh2_main_qb_final_battle_main_objective_defeat_high_elves";
	race_1_advice = "wh2.battle.advice.final_battle_mid.003";
elseif gb:get_army(ai_alliance, 2, "lzd_wave_1") then
	ga_ai_race_1 = gb:get_army(ai_alliance, 2);
	
	ga_ai_race_1_wave_1 = gb:get_army(ai_alliance, 2, "lzd_wave_1");
	
	ga_ai_race_1_wave_2 = gb:get_army(ai_alliance, 2, "lzd_wave_2");
	
	race_1_hint = "wh2_main_qb_final_battle_hint_objective_defeat_lizardmen";
	race_1_objective = "wh2_main_qb_final_battle_main_objective_defeat_lizardmen";
	race_1_advice = "wh2.battle.advice.final_battle_mid.002";
end;

-- second reinforcing race - high elves OR dark elves OR lizardmen
-- note: depending on load order, can be in army 3 OR 4
local race_2_hint = "";
local race_2_objective = "";
local race_2_advice = "";

if gb:get_army(ai_alliance, 3, "def_wave_1") then
	ga_ai_race_2 = gb:get_army(ai_alliance, 3);
	
	ga_ai_race_2_wave_1 = gb:get_army(ai_alliance, 3, "def_wave_1");
	
	ga_ai_race_2_wave_2 = gb:get_army(ai_alliance, 3, "def_wave_2");
	
	race_2_hint = "wh2_main_qb_final_battle_hint_objective_defeat_dark_elves";
	race_2_objective = "wh2_main_qb_final_battle_main_objective_defeat_dark_elves";
	race_2_advice = "wh2.battle.advice.final_battle_mid.004";
elseif gb:get_army(ai_alliance, 3, "hef_wave_1") then
	ga_ai_race_2 = gb:get_army(ai_alliance, 3);
	
	ga_ai_race_2_wave_1 = gb:get_army(ai_alliance, 3, "hef_wave_1");
	
	ga_ai_race_2_wave_2 = gb:get_army(ai_alliance, 3, "hef_wave_2");
	
	race_2_hint = "wh2_main_qb_final_battle_hint_objective_defeat_high_elves";
	race_2_objective = "wh2_main_qb_final_battle_main_objective_defeat_high_elves";
	race_2_advice = "wh2.battle.advice.final_battle_mid.003";
elseif gb:get_army(ai_alliance, 3, "lzd_wave_1") then
	ga_ai_race_2 = gb:get_army(ai_alliance, 3);
	
	ga_ai_race_2_wave_1 = gb:get_army(ai_alliance, 3, "lzd_wave_1");
	
	ga_ai_race_2_wave_2 = gb:get_army(ai_alliance, 3, "lzd_wave_2");
	
	race_2_hint = "wh2_main_qb_final_battle_hint_objective_defeat_lizardmen";
	race_2_objective = "wh2_main_qb_final_battle_main_objective_defeat_lizardmen";
	race_2_advice = "wh2.battle.advice.final_battle_mid.002";
elseif gb:get_army(ai_alliance, 4, "def_wave_1") then
	ga_ai_race_2 = gb:get_army(ai_alliance, 4);
	
	ga_ai_race_2_wave_1 = gb:get_army(ai_alliance, 4, "def_wave_1");
	
	ga_ai_race_2_wave_2 = gb:get_army(ai_alliance, 4, "def_wave_2");
	
	race_2_hint = "wh2_main_qb_final_battle_hint_objective_defeat_dark_elves";
	race_2_objective = "wh2_main_qb_final_battle_main_objective_defeat_dark_elves";
	race_2_advice = "wh2.battle.advice.final_battle_mid.004";
elseif gb:get_army(ai_alliance, 4, "hef_wave_1") then
	ga_ai_race_2 = gb:get_army(ai_alliance, 4);
	
	ga_ai_race_2_wave_1 = gb:get_army(ai_alliance, 4, "hef_wave_1");
	
	ga_ai_race_2_wave_2 = gb:get_army(ai_alliance, 4, "hef_wave_2");
	
	race_2_hint = "wh2_main_qb_final_battle_hint_objective_defeat_high_elves";
	race_2_objective = "wh2_main_qb_final_battle_main_objective_defeat_high_elves";
	race_2_advice = "wh2.battle.advice.final_battle_mid.003";
elseif gb:get_army(ai_alliance, 4, "lzd_wave_1") then
	ga_ai_race_2 = gb:get_army(ai_alliance, 4);
	
	ga_ai_race_2_wave_1 = gb:get_army(ai_alliance, 4, "lzd_wave_1");
	
	ga_ai_race_2_wave_2 = gb:get_army(ai_alliance, 4, "lzd_wave_2");
	
	race_2_hint = "wh2_main_qb_final_battle_hint_objective_defeat_lizardmen";
	race_2_objective = "wh2_main_qb_final_battle_main_objective_defeat_lizardmen";
	race_2_advice = "wh2.battle.advice.final_battle_mid.002";
end;

-- grey seer clan reinforcements
-- note: depending on load order, can be in army 1 OR 3 OR 4
if gb:get_army(ai_alliance, 1, "reinforcements") then
	ga_ai_grey_seer_clan = gb:get_army(ai_alliance, 1, "reinforcements");
elseif gb:get_army(ai_alliance, 3, "reinforcements") then	
	ga_ai_grey_seer_clan = gb:get_army(ai_alliance, 3, "reinforcements");
else	
	ga_ai_grey_seer_clan = gb:get_army(ai_alliance, 4, "reinforcements");
end;

-------ARMY BEHAVIOUR-------
ga_player:grant_infinite_ammo_on_message("battle_started");
ga_player:add_winds_of_magic_reserve_on_message("battle_started", 100);

ga_ai_defence:message_on_rout_proportion("defence_defeated", 0.8);
ga_ai_defence:rout_over_time_on_message("defence_defeated", 10000);

ga_ai_race_1_wave_1:reinforce_on_message("defence_defeated");
ga_ai_race_1_wave_1:message_on_proximity_to_enemy("race_1_wave_1_engaged", 100);
ga_ai_race_1_wave_1:message_on_rout_proportion("race_1_wave_1_engaged", 1);
ga_ai_race_1_wave_2:reinforce_on_message("race_1_wave_1_engaged");

ga_ai_race_1:message_on_rout_proportion("race_2_reinforce", 0.7);
ga_ai_race_1:rout_over_time_on_message("race_2_reinforce", 10000);
ga_ai_race_1:message_on_rout_proportion("race_1_defeated", 1);

ga_ai_race_2_wave_1:reinforce_on_message("race_2_reinforce");
ga_ai_race_2_wave_1:message_on_proximity_to_enemy("race_2_wave_1_engaged", 100);
ga_ai_race_2_wave_1:message_on_rout_proportion("race_2_wave_1_engaged", 1);
ga_ai_race_2_wave_2:reinforce_on_message("race_2_wave_1_engaged");

ga_ai_race_2:message_on_rout_proportion("grey_seer_clan_reinforce", 0.7);
ga_ai_race_2:rout_over_time_on_message("grey_seer_clan_reinforce", 10000);
ga_ai_race_2:message_on_rout_proportion("race_2_defeated", 1);

ga_ai_grey_seer_clan:reinforce_on_message("grey_seer_clan_reinforce");

ga_ai_grey_seer_clan:message_on_rout_proportion("grey_seer_clan_begin_rout", 0.8);
ga_ai_grey_seer_clan:rout_over_time_on_message("grey_seer_clan_begin_rout", 20000);

-------OBJECTIVES-------
objective = "wh2_main_qb_final_battle_main_objective_defeat_grey_seer_clan_defence";
hint = "wh2_main_qb_final_battle_hint_objective_defeat_grey_seer_clan_defence";

if is_player_skaven then
	objective = "wh2_main_qb_final_battle_main_objective_defeat_high_elf_defence";
	hint = "wh2_main_qb_final_battle_hint_objective_defeat_high_elf_defence";
end;	

gb:set_objective_on_message("deployment_started", objective);

gb:complete_objective_on_message("defence_defeated", objective);

gb:set_objective_on_message("defence_defeated", race_1_objective);

gb:complete_objective_on_message("race_1_defeated", race_1_objective);

gb:set_objective_on_message("race_2_reinforce", race_2_objective);

gb:complete_objective_on_message("race_2_defeated", race_2_objective);

gb:set_objective_on_message("grey_seer_clan_reinforce", "wh2_main_qb_final_battle_main_objective_defeat_grey_seer_clan_reinforcements");

-------HINTS-------
gb:queue_help_on_message("battle_started", hint);

gb:queue_help_on_message("defence_defeated", "wh2_main_qb_final_battle_hint_objective_army_ability");

gb:queue_help_on_message("defence_defeated", race_1_hint);

gb:queue_help_on_message("race_2_reinforce", race_2_hint);

gb:queue_help_on_message("grey_seer_clan_reinforce", "wh2_main_qb_final_battle_hint_objective_defeat_grey_seer_clan_reinforcements");

-------ARMY ABILITY-------
local army_abilities = {
	"wh2_main_army_abilities_vortic_enrichment",
	"wh2_main_army_abilities_vortic_blast"
};

function show_army_abilities(value)
	local army_ability_parent = get_army_ability_parent();
	
	for i = 1, #army_abilities do
		find_uicomponent(army_ability_parent, "button_holder_" .. army_abilities[i]):SetVisible(value);
	end;
end;

function highlight_army_ability(value)
	local army_ability_parent = get_army_ability_parent();
	
	for i = 1, #army_abilities do
		find_uicomponent(army_ability_parent, "button_ability_" .. army_abilities[i]):Highlight(value, false, 100);
	end;
end;

function get_army_ability_parent()
	return find_uicomponent(core:get_ui_root(), "army_ability_parent");
end;

show_army_abilities(false);

sm:add_listener(
	"defence_defeated",
	function()
		show_army_abilities(true);
		
		bm:callback(
			function()
				highlight_army_ability(true);
			end,
			1000
		);
		
		bm:callback(
			function()
				highlight_army_ability(false);
			end,
			7000
		);
	end
);

--------HORNED RAT VO----------
local index = 1;
local new_index = 1;

sm:add_listener(
	"battle_started",
	function()
		bm:repeat_callback(
			function()
				if bm:advice_finished() then
					local new_vo_picked = false;
					
					while not new_vo_picked do
						new_index = bm:random_number(#horned_rat_vo - 1);
						
						if new_index ~= index then
							new_vo_picked = true;
							index = new_index;
						end;
					end;
					
					play_sound(bm:get_origin(), horned_rat_vo[index]);
				end;
			end,
			60000,
			"horned_rat_vo"
		);
	end
);

gb:play_sound_on_message("grey_seer_clan_reinforce", horned_rat_vo[#horned_rat_vo], bm:get_origin(), 3000);

--------ADVICE----------
local intro_advice = "wh2.battle.advice.final_battle_intro.001";

if is_player_skaven then
	intro_advice = "wh2.battle.advice.final_battle_intro.002";
end;

gb:advice_on_message("battle_started", intro_advice);

gb:advice_on_message("defence_defeated", "wh2.battle.advice.final_battle_mid.001");

gb:advice_on_message("defence_defeated", race_1_advice, 15000);

gb:advice_on_message("race_1_defeated", race_2_advice, 15000);

gb:advice_on_message("grey_seer_clan_reinforce", "wh2.battle.advice.final_battle_mid.005", 15000);

ga_player:message_on_victory("player_wins");
gb:advice_on_message("player_wins", "wh2.battle.advice.final_battle_victory.001");

--gb:set_custom_loading_screen_on_message("player_wins", loading_screen_key);

sm:add_listener(
	"player_wins",
	function()
		core:add_listener(
			"set_loading_screen",
			"ComponentLClickUp",
			function(context)
				return context.string == "button_dismiss_results";
			end,
			function()
				common.set_custom_loading_screen_key(loading_screen_key);
			end,
			false
		);
	end
);

ga_player:message_on_defeat("player_loses");
gb:advice_on_message("player_loses", "wh2.battle.advice.final_battle_defeat.001");