



---------------------------------------------------------
--
-- setup player involvement in main attack
-- player has either destroyed the artillery or approached the main battle
--
---------------------------------------------------------


bool_player_involved_in_main_battle_phase = false;

function start_player_involvement_in_main_battle_phase(reason, show_artillery_destroyed_cutscene)
	if bool_player_involved_in_main_battle_phase then
		return;
	end;
	
	bool_player_involved_in_main_battle_phase = true;
	
	bm:out("start_player_involvement_in_main_battle_phase() called, reason: " .. tostring(reason));
	
	bm:remove_process("artillery_defence_monitors");
	
	if show_artillery_destroyed_cutscene then
		-- compute some camera co-ordinate offsets from the artillery
		local pos_artillery_cam_targ = sunits_enemy_artillery:get_closest(sunits_player_all:centre_point()).unit:position();
		local pos_artillery_cam = v_offset(pos_artillery_cam_targ, -60, 20, 30);

		--[[
		local pos_main_battle_cam_targ = sunits_allied_defenders:centre_point();
		local pos_main_battle_cam = v_offset(pos_main_battle_cam_targ, 40, 30, 10);
		]]
		
		play_cutscene_artillery_destroyed(pos_artillery_cam, pos_artillery_cam_targ--[[, pos_main_battle_cam, pos_main_battle_cam_targ]]);
	else
		start_player_joins_main_attack_monitors(false);
	end;
end;









---------------------------------------------------------
--
-- artillery destroyed cutscene
--
---------------------------------------------------------


cutscene_artillery_destroyed_length = 12500;

cutscene_artillery_destroyed = cutscene:new(
	"cutscene_artillery_destroyed",			 				-- unique string name for cutscene
	sunits_player_all,	 									-- unitcontroller over player's army
	cutscene_artillery_destroyed_length,					-- duration of cutscene in ms
	function()
		start_player_joins_main_attack_monitors(true);
	end														-- what to call when cutscene is finished
);


cutscene_artillery_destroyed:set_should_disable_unit_ids(true);
cutscene_artillery_destroyed:set_restore_cam(2);
cutscene_artillery_destroyed:set_close_advisor_on_end(false);
cutscene_artillery_destroyed:set_skippable(
	true,
	function()
		cam:fade(true, 0);
		
		bm:callback(
			function()
				reposition_players_army_for_main_attack(true);
				cam:fade(false, 0.5);
			end,
			500
		);
	end
);

function play_cutscene_artillery_destroyed(pos_artillery_cam, pos_artillery_cam_targ)
	
	cutscene_artillery_destroyed:action(function() cam:move_to(pos_artillery_cam, pos_artillery_cam_targ, 2, false, 0) end, 500);
	
	cutscene_artillery_destroyed:action(function() play_artillery_destroyed_advice() end, 1000);

	cutscene_artillery_destroyed:action(function() cam:move_to(v(62.6, 397.0, -92.3), v(23.7, 370.9, -70), 3, false, 0) end, 5000);

	cutscene_artillery_destroyed:action(function() reposition_players_army_for_main_attack(false) end, 8000);
		
	cutscene_artillery_destroyed:start();
end;


function reposition_players_army_for_main_attack(release_control)
	core:call_once(
		"reposition_players_army_for_main_attack",
		function()
			sunits_player_all:disordered_teleport(v(-30, -240), 60, release_control);
		end
	);
end;


function play_artillery_destroyed_advice()
	core:call_once(
		"artillery_destroyed_advice", 
		function()
			-- The cannons are destroyed! Yet Skollden's army still attacks the beacon. They're vulnerable from behind. Strike now, while they're engaged!
			bm:queue_advisor("wh3_main_scenario_01_0110");
		end
	);	
end;

















---------------------------------------------------------
--
-- main attack player monitor
--
---------------------------------------------------------

attack_main_army_objective_key = "wh3_main_scenario_01_prologue_intro_attacking_04";


function start_player_joins_main_attack_monitors(play_advice)

	bm:clear_infotext();

	local show_objective_func = function()
		bm:set_objective_with_leader(attack_main_army_objective_key);
	end;
	
	-- Show advice related to the artillery being destroyed. If it's already been displayed in the cutscene then just  the infotext and objective will be displayed.
	-- Otherwise, just show the objective.
	if play_advice then
		play_artillery_destroyed_advice();

		bm:add_infotext_with_leader(
			"wh2.battle.intro.info_025",
			"wh2.battle.intro.info_024",
			"wh2.battle.intro.info_026",
			show_objective_func
		);
	else
		show_objective_func();
	end;


	-- Watch for the player's general closing on the enemy and trigger the ability-gained cutscene immediately
	bm:watch(
		function()
			return distance_between_forces(sunit_player_01, sunits_enemy_main) < 25;
		end,
		0,
		function()
			play_cutscene_ability_gained()
		end,
		"player_main_army_engagement"
	);


	-- Watch for the player's forces closing on the enemy and trigger advice after a short time
	bm:watch(
		function()
			return distance_between_forces(sunits_player_all_no_general, sunits_enemy_main) < 20;
		end,
		20000,
		function()
			-- Your forces struggle without you leading them! Join the fight, rally your troops!
			bm:queue_advisor("wh3_main_scenario_01_0121");
		end,
		"player_main_army_engagement"
	);
end;










---------------------------------------------------------
--
-- cutscene ability gained
--
---------------------------------------------------------


cutscene_ability_gained = cutscene:new_from_cindyscene(
	"cutscene_ability_gained",				 									-- unique string name for cutscene
	sunits_player_all,	 														-- unitcontroller over player's army
	function() 																	-- what to call when cutscene is finished
		bm:hide_subtitles(); 
		prepare_to_start_unit_ability_tour(); 
		bm:callback(function() bm:enable_unit_ids(false) end, 100) 
		bm:hide_help_message(false)
	end,																
	"script/battle/scenario_battles/_cutscene/managers/01_prologue_intro_yuri_ability.CindySceneManager",
	0,
	0
)

cutscene_ability_gained:action(
	function() 
		play_sound_2D(new_sfx("Play_Movie_WH3_Prologue_Battle_1_Sweetener_Layer_04"))

		-- Ursun's Roar sound
		play_sound_2D(new_sfx("Play_Movie_WH3_Prologue_Battle_1_Ursun_Roar"))
		
		bm:queue_help_message(
			"wh3_main_prologue_ursun_yuri_ability_cutscene", 
			10000, 
			2000, 
			true, 
			true,
			false
		)

	end, 
	0
)
cutscene_ability_gained:set_post_cutscene_fade_time(0.5, 0)

function play_cutscene_ability_gained()
	bm:out("Playing ability-gained cutscene")
	bm:remove_process("player_main_army_engagement")

	bm:stop_advisor_queue(true);
	cutscene_ability_gained:start();
end;



function make_all_combatants_invisible_for_ability_gained_cutscene(make_invisible)
	make_invisible = not not make_invisible;

	sunits_player_all_no_general:set_enabled(not make_invisible);
	sunits_allied_defenders:set_invisible_to_all(make_invisible);
	sunits_enemy_all:set_invisible_to_all(make_invisible);
end;




















function prepare_to_start_unit_ability_tour()

	-- Setup a restore camera position behind the player's general
	local cam_targ = v_offset(sunit_player_01.unit:position(), 0, 2, 0);
	local cam_pos = v_offset(cam_targ, 0, 10, -20);

	cam:move_to(cam_pos, cam_targ, 0, false, 0);

	bm:remove_objective(attack_main_army_objective_key);

	bm:callback(
		function()
			bm:clear_selection()
			
			local aa = intro_battle_abilities_advice:new(
				-- Yuri! You are a prince of Kislev – let your kinsmen hear your roar; fill them with Ursun's courage!
				"wh3_main_scenario_01_0125",
				sunit_player_01,
				sunits_player_all,
				sunits_enemy_main,
				-- Select your Lord
				"wh3_main_scenario_01_prologue_intro_selection_03",
				-- Activate your Lord's unit ability
				"wh3_main_scenario_01_prologue_intro_unit_ability_01",
				function() 
					prepare_to_play_cutscene_ability_used() 
					core:remove_listener("ComponentLClickUpSelectYuriByIcon")
				end
			);
			
			aa:add_infotext(
				"wh2.battle.intro.info_120",
				"wh2.battle.intro.info_121",
				"wh2.battle.intro.info_122"
			);

			aa:set_should_modify_time(false);
			aa:set_should_restore_camera(false);
			aa:keep_current_objectives(true)
			aa:set_should_track_unit_with_camera(true)
			
			aa:start();

			core:add_listener(
				"ComponentLClickUpSelectYuriByIcon",
				"ComponentLClickUp",
				function(context) 
					return context.string == "icon" and uicomponent_descended_from(UIComponent(context.component), "script_ping_parent");
				end,
				function()
					sunit_player_01.unit:select_in_ui()
				end,
				true
			)
		end,
		1000
	);
	

	-- slow down time
	bm:modify_battle_speed(0.2);

	bm:callback(
		function()
			cam:fade(false, 0.5);
		end,
		0.1
	);
end;















---------------------------------------------------------
--
-- cutscene ability used
--
---------------------------------------------------------


cutscene_ability_used_length = 7000;

cutscene_ability_used = cutscene:new(
	"cutscene_ability_used",				 				-- unique string name for cutscene
	sunits_player_all,	 									-- unitcontroller over player's army
	cutscene_ability_used_length,							-- duration of cutscene in ms
	function()
		progress_to_main_battle_final_phase("ability used");
	end														-- what to call when cutscene is finished
);


cutscene_ability_used:set_should_disable_unit_ids(false);
cutscene_ability_used:set_close_advisor_on_end(false);
cutscene_ability_used:set_should_disable_unit_ids(true);
cutscene_ability_used:set_skippable(
	true,
	function()
	end
);



function play_cutscene_ability_used(closest_sunit, second_closest_sunit)

	-- calculate and set a restore camera position
	local restore_cam_targ = v_offset(sunit_player_01.unit:position(), 0, 5, 0);
	local restore_cam_pos = v_offset(restore_cam_targ, 0, 20, -40);
	cutscene_ability_used:set_restore_cam(2, restore_cam_pos, restore_cam_targ);

	cutscene_ability_used:action(
		function()
			local cam_target = v_offset(closest_sunit.unit:position(), 0, 2, 0);
			local cam_pos = v_offset(position_along_line(cam_target, sunit_player_01.unit:position(), -30), 0, 10, 0);
			cam:move_to(cam_pos, cam_target, 2, false, 0);
		end,
		0
	);

	cutscene_ability_used:action(
		function()
			-- Your war cry inspires your soldiers! See how their spirit is renewed!
			bm:queue_advisor("wh3_main_scenario_01_0126");

			--Set up a metric variable to be used in campaign later
			core:svr_save_bool("sbool_prologue_first_battle_ability_used", true);
		end,
		1000
	);

	cutscene_ability_used:action(
		function()
			local cam_target = v_offset(second_closest_sunit.unit:position(), 0, 2, 0);
			local cam_pos = v_offset(position_along_line(cam_target, sunit_player_01.unit:position(), -30), 0, 10, 0);
			cam:move_to(cam_pos, cam_target, 3, false, 0);
		end,
		4000
	);

	cutscene_ability_used:set_should_disable_unit_ids(false)
		
	cutscene_ability_used:start();
end;


function prepare_to_play_cutscene_ability_used()
	-- find the closest player unit to the player general
	local closest_sunit = sunits_player_all_no_general:get_closest(sunit_player_01.unit:position());
	local closest_sunit_position = closest_sunit.unit:position();

	-- try and find a second unit that is more than a certain distance away and within a certain distance of a non-routing enemy
	local _, __, second_closest_sunit = get_closest_unit(
		sunits_player_all_no_general, 
		sunit_player_01.unit:position(), 
		false, 
		function(unit)
			local unit_position = unit:position();
			return unit ~= closest_sunit.unit and 
				unit_position:distance_xz(closest_sunit_position) > 20 and
				is_close_to_position(sunits_enemy_main, unit_position, 30, false, true) 
		end
	);

	-- if we didn't find a second unit, then try again and be less fussy this time
	if not second_closest_sunit then
		_, __, second_closest_sunit = get_closest_unit(sunits_player_all_no_general, sunit_player_01.unit:position(), false, function(unit) return unit ~= closest_sunit.unit end);
	end;

	play_cutscene_ability_used(closest_sunit, second_closest_sunit);
end;














---------------------------------------------------------
--
-- main battle final phase
--
---------------------------------------------------------

bool_main_battle_final_phase_entered = false;


function progress_to_main_battle_final_phase(reason)

	if bool_main_battle_final_phase_entered then
		return;
	end;

	bool_main_battle_final_phase_entered = true;

	out("main battle final phase entered, reason: " .. tostring(reason));
	
	-- remove protections from enemy
	sunits_enemy_main:max_casualties(0, true);
	sunits_enemy_main:morale_behavior_default();
	sunits_enemy_main:set_invincible_for_time_proportion(0);
	
	-- reduce protections for allies
	sunits_player_all:max_casualties(0.45, true);
	
	-- start a kill aura on the player
	sunits_player_all:start_kill_aura(sunits_enemy_main, 20, 0.04);

	local num_enemy_main_units_routing_upper_threshold = sunits_enemy_main:count() * 0.5;
	bm:watch(
		function()
			local num_enemy_main_units_routing = num_units_routing(sunits_enemy_main);
			if num_enemy_main_units_routing > num_enemy_main_units_routing_upper_threshold then
				bm:out("More than half of the enemy main force are routing - beginning to rout the rest");
				return true
			end
		end,
		0,
		function()
			sunits_enemy_main:rout_over_time(15000);

			bm:callback(
				function()
					player_has_won(objective_key);
				end,
				3000
			);
		end
	);
end;
























---------------------------------------------------------
--
-- player defeat
--
---------------------------------------------------------

--[[
function stop_phase_two_battle()
	bm:remove_process("phase_two_battle");
	bm:remove_process("player_cavalry_hurry_up");
end;


function player_has_lost_phase_two()
	stop_phase_two_battle()
	bm:stop_advisor_queue(true);
	
	bm:queue_advisor(
		-- The last of your forces flee, my Lord! This battle is lost: let us retreat and regroup!
		"wh2.battle.intro.250"	
	);
	bm:add_infotext(
		1,
		"wh2.battle.intro.info_150",
		"wh2.battle.intro.info_151"
	);
	
	rout_player_army();
	
	bm:callback(
		function()
			bm:end_battle();
		end,
		10000
	);
end;
]]



function rout_player_army()
	bm:out("rout_player_army() called");
	
	stop_make_army_vulnerable_if_separated();
	
	sunits_player_all:rout_over_time(10000);
	
	bm:callback(
		function()
			alliance_enemy:force_battle_victory();
		end,
		10000
	);
end;











---------------------------------------------------------
--
-- player victory
--
---------------------------------------------------------


function player_has_won(objective_key)

	--Set up a metric variable to be used in campaign later
	core:svr_save_bool("sbool_prologue_first_battle_won", true);

	bm:change_victory_countdown_limit(-1);

	-- override the loading screen
	override_loading_screen();

	bm:clear_infotext();

	bm:queue_advisor(
		-- The enemy are dead or scattered. They flee the field! We are the Bear's wrath. But Skollden, the Wolf, still lives. 
		"wh3_main_scenario_01_0130"
	);

	bm:add_infotext_with_leader(
		"wh2.battle.intro.info_150",
		"wh2.battle.intro.info_151"
	);

	get_help_page_manager():hide_panel();
	
	bm:callback(
		function()
			cam:fade(true, 1);

			bm:callback(
				function()
					play_cutscene_outro();
				end,
				1000
			);
		end,
		12000
	);
end;














---------------------------------------------------------
--
-- outro cutscene
--
---------------------------------------------------------

cutscene_outro = cutscene:new_from_cindyscene(
	"cutscene_outro", 												-- unique string name for cutscene
	sunits_player_all,	 											-- unitcontroller over player's army
	function() end_battle_in_player_victory() end,					-- what to call when cutscene is finished
	"script/battle/scenario_battles/_cutscene/managers/01_prologue_intro_retreat.CindySceneManager",
	0,
	0
);

-- cutscene_outro:set_debug(true);
-- cutscene_outro:set_post_cutscene_fade_time(0);
cutscene_outro:set_should_disable_unit_ids(true);
cutscene_outro:set_skippable(true);

function play_cutscene_outro()
	
	cutscene_outro:action(function() cam:fade(false, 0.5) end, 0);

	cutscene_outro:start();
	local end_sfx = new_sfx("Play_Movie_WH3_Prologue_Battle_1_Sweetener_Layer_03");
	play_sound_2D(end_sfx);
end;







function end_battle_in_player_victory()
	
	-- set variable
	core:svr_save_bool("sbool_load_post_intro_campaign", true) --sbool_load_intro_campaign

	sunits_player_all:save_state_to_svr("player_army");

	bm:change_victory_countdown_limit(0);
	alliance_player:force_battle_victory();
end;





















---------------------------------------------------------
--
-- end loading screen
--
---------------------------------------------------------

bool_battle_is_being_replayed = false;

function override_loading_screen_on_skip()

	sunits_player_all:save_state_to_svr("player_army");

	core:add_listener(
		"skip_battle_listener",
		"ComponentLClickUp",
		function(context) return context.string == "button_rematch" end,
		function() override_loading_screen(true) end,
		false
	);
end;


function override_loading_screen(battle_is_being_replayed)

	--Set up a metric variable to be used in campaign later
	core:svr_save_bool("sbool_prologue_first_battle_replayed", true);
	
	if battle_is_being_replayed then
		local loading_screen_record = "prologue_battle_1_intro";
		bm:out("Overriding loading screen with loading screen with key " .. loading_screen_record);
		common.set_custom_loading_screen_key(loading_screen_record);
	else
		local loading_screen_record = "prologue_battle_1_outro";
		bm:out("Overriding loading screen with dynamic loading screen with key " .. loading_screen_record);
		common.setup_dynamic_loading_screen(loading_screen_record, "prologue");
	end;

end;
