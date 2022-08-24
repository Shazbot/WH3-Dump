

-- for topic leader - remove/refactor at some point
package.path = package.path .. ";data/script/battle/intro_battles/?.lua";
require("wh2_intro_battle");

-- helper functions
-- require("script.battle.scripted_tours.scripted_tour_helper_functions");


require("scripted_tour_helper_functions");
require("siege_battle_tours");
require("battle_fundamentals_tour");


local cam = bm:camera();

local sunits_local_player = bm:get_scriptunits_for_local_players_army();
local sunits_enemy_main = bm:get_scriptunits_for_main_enemy_army_to_local_player();













-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
-- DEPLOYMENT
-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------

do
	nt_deployment = navigable_tour:new(
		"deployment",																-- unique name
		function()																	-- end callback
		end,
		"ui_text_replacements_localised_text_wh3_main_battle_scripted_tour_deployment_name"
	);

	nt_deployment:set_allow_camera_movement(true);

	-- validation rules for this navigable tour
	nt_deployment:add_validation_rule(
		function()
			return core:is_battle()
		end,
		"random_localisation_strings_string_scripted_tour_invalid_not_battle"
	);

	nt_deployment:add_validation_rule(
		function()
			return not bm:is_multiplayer()
		end,
		"random_localisation_strings_string_scripted_tour_invalid_not_singleplayer"
	);

	nt_deployment:add_validation_rule(
		function()
			return bm:battle_type() ~= "land_ambush"
		end,
		"random_localisation_strings_string_scripted_tour_invalid_is_ambush_battle"
	);

	nt_deployment:add_validation_rule(
		function()
			return bm:get_current_phase_name() == "Deployment"
		end,
		"random_localisation_strings_string_scripted_tour_invalid_player_not_deployment"
	);

	nt_deployment:add_validation_context_change_listener(
		"BattleConflictPhaseCommenced"
	);






	-------------------------------------------------
	--- Section 01 : Intro
	-------------------------------------------------
	
	local nts_deployment_zone = st_helper.navigable_tour_section_battle_factory(
		"deployment_zone",									-- section name
		function()
			local player_centre_pos = sunits_local_player:centre_point();
			local enemy_centre_pos = sunits_enemy_main:centre_point();
			local pos_centre = centre_point_table({player_centre_pos, enemy_centre_pos});

			-- bm:out("player centre " .. v_to_s(player_centre_pos) .. ", enemy_centre_pos " .. v_to_s(enemy_centre_pos) .. ", pos centre is " .. v_to_s(pos_centre));
			
			return pos_centre, st_helper.get_offset_camera_positions_by_offset_and_bearing(
				pos_centre,
				400, 
				-200, 
				get_bearing(player_centre_pos, enemy_centre_pos)
			);
		end,												-- camera positions generator
		nil,												-- advice key
		{
			"wh3_main_st_deployment_0010",
			"wh3_main_st_deployment_0011",
			"wh3_main_st_deployment_0012",
			"wh3_main_st_deployment_0013"
		}													-- infotext
	);

	-- make the deployment zone flash, and then stop it flashing when we proceed
	nts_deployment_zone:action(
		function()
			local local_player_army = sunits_local_player:item(1).unit:army();
			local_player_army:highlight_deployment_areas(true);

			local main_enemy_army = sunits_enemy_main:item(1).unit:army();
			main_enemy_army:highlight_deployment_areas(true);

			nts_deployment_zone:add_skip_action(
				function()
					local_player_army:highlight_deployment_areas(false);
					main_enemy_army:highlight_deployment_areas(false);
				end
			);
		end,
		3000
	);


	

	-------------------------------------------------
	--- Section 02 : Time Limit
	-------------------------------------------------

	local time_limit_infotext;
	if bm:player_is_attacker() then
		time_limit_infotext = {
			"wh3_main_st_deployment_0020",
			"wh3_main_st_deployment_0021"
		};
	else
		time_limit_infotext = {
			"wh3_main_st_deployment_0020",
			"wh3_main_st_deployment_0022"
		};
	end;
	
	local nts_time_limit = st_helper.navigable_tour_section_battle_factory(
		"time_limit",								-- section name
		function() 
			return st_helper.get_offset_camera_positions_from_sunits(
				sunits_local_player,
				0,
				-60,
				nil,
				nil,
				nil,
				true				-- relaxed pose
			);
		end,												-- camera positions generator
		nil,												-- advice key
		{
			"wh3_main_st_deployment_0020",
			"wh3_main_st_deployment_0021"
		}													-- infotext
	);
	
	nts_time_limit:action(
		function()
			-- show the top bar and allow interaction (so that it's not greyed out)
			bm:show_top_bar(true);
			bm:steal_input_focus(false);
		end,
		3200
	);


	nts_time_limit:action(
		function()
			-- show time limit text pointer
			local ap_time_limit = active_pointer:new(
				"time_limit", 
				"topright", 
				find_uicomponent(core:get_ui_root(), "hud_battle", "BOP_frame", "docked_holder", "simple_timer"), 
				"ui_text_replacements_localised_text_wh3_main_st_battle_time_limit", 
				0.5, 
				1, 
				200,
				true
			);

			ap_time_limit:set_style("minimalist_dont_close");

			ap_time_limit:show();

			nts_time_limit:add_skip_action(
				function()
					core:hide_all_text_pointers();
				end
			);
		end,
		4500
	);


	nts_time_limit:action(
		function()
			-- show balance of power text pointer
			local ap_bop = active_pointer:new(
				"bop", 
				"topleft", 
				find_uicomponent(core:get_ui_root(), "hud_battle", "BOP_frame", "kill_ratio_PH"), 
				"ui_text_replacements_localised_text_wh2_intro_battle_balance_of_power", 
				0.5, 
				1, 
				250,
				true
			);

			ap_bop:set_style("minimalist_dont_close");

			ap_bop:show();
		end,
		5000
	);



	-------------------------------------------------
	--- Section 03 : Review Positions
	-------------------------------------------------
	
	local review_infotext;
	if bm:player_is_attacker() then
		review_infotext = {
			"wh3_main_st_deployment_0030",
			"wh3_main_st_deployment_0031",
			"wh3_main_st_deployment_0033",
			"wh3_main_st_deployment_0034"
		};
	else
		review_infotext = {
			"wh3_main_st_deployment_0030",
			"wh3_main_st_deployment_0032",
			"wh3_main_st_deployment_0033",
			"wh3_main_st_deployment_0034"
		};
	end;

	local nts_review = st_helper.navigable_tour_section_battle_factory(
		"review",											-- section name
		function() 
			return st_helper.get_offset_camera_positions_from_sunits(
				sunits_local_player,
				0,
				-90,
				nil,
				nil,
				nil,
				true				-- relaxed pose
			);
		end,												-- camera positions generator
		nil,												-- advice key
		review_infotext										-- infotext
	);






	-- add all sections to tour in order
	nt_deployment:add_navigable_section(nts_deployment_zone);
	nt_deployment:add_navigable_section(nts_time_limit);
	nt_deployment:add_navigable_section(nts_review);




	-- add startup actions
	nt_deployment:start_action(
		function()
			st_helper.setup_tour_start(nt_deployment);
		end,
		0
	);


	-- add end actions
	nt_deployment:end_action(
		function()
			st_helper.setup_tour_end(nt_deployment);
		end
	);


end;
















-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
-- UNIT TYPES
-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------

do
	nt_unit_types = navigable_tour:new(
		"unit_types",																-- unique name
		function()																	-- end callback
		end,
		"ui_text_replacements_localised_text_wh3_main_battle_scripted_tour_unit_types_name"
	);

	nt_unit_types:set_allow_camera_movement(false);

	-- validation rules for this navigable tour
	nt_unit_types:add_validation_rule(
		function()
			return core:is_battle()
		end,
		"random_localisation_strings_string_scripted_tour_invalid_not_battle"
	);

	nt_unit_types:add_validation_rule(
		function()
			return not bm:is_multiplayer()
		end,
		"random_localisation_strings_string_scripted_tour_invalid_not_singleplayer"
	);







	-------------------------------------------------
	--- Section 01 : Infantry
	-------------------------------------------------
	
	local nts_infantry = st_helper.navigable_tour_section_battle_factory(
		"infantry",											-- section name
		nil,												-- camera positions generator
		nil,												-- advice key
		{
			"wh3_main_st_unit_types_0011",
			"wh3_main_st_unit_types_0012",
			"wh3_main_st_unit_types_0013",
			"wh3_main_st_unit_types_0014"
		},													-- infotext
		nil,												-- advice/infotext delay
		nil,												-- objective key
		nil,												-- objective completion test
		nil,												-- leave objective after completion
		"scripted_tours/unit_types/scripted_tour_infantry"	-- movie path
	);

	

	-------------------------------------------------
	--- Section 02 : Mounted Units
	-------------------------------------------------
	
	local nts_mounted_units = st_helper.navigable_tour_section_battle_factory(
		"mounted_units",									-- section name
		nil,												-- camera positions generator
		nil,												-- advice key
		{
			"wh3_main_st_unit_types_0021",
			"wh3_main_st_unit_types_0022",
			"wh3_main_st_unit_types_0023",
			"wh3_main_st_unit_types_0024"
		},													-- infotext
		nil,												-- advice/infotext delay
		nil,												-- objective key
		nil,												-- objective completion test
		nil,												-- leave objective after completion
		"scripted_tours/unit_types/scripted_tour_cav"		-- movie path
	);



	-------------------------------------------------
	--- Section 03 : Missile
	-------------------------------------------------
	
	local nts_missile_units = st_helper.navigable_tour_section_battle_factory(
		"missile_units",									-- section name
		nil,												-- camera positions generator
		nil,												-- advice key
		{
			"wh3_main_st_unit_types_0031",
			"wh3_main_st_unit_types_0032",
			"wh3_main_st_unit_types_0033",
			"wh3_main_st_unit_types_0034"
		},													-- infotext
		nil,												-- advice/infotext delay
		nil,												-- objective key
		nil,												-- objective completion test
		nil,												-- leave objective after completion
		"scripted_tours/unit_types/scripted_tour_missile"	-- movie path
	);



	-------------------------------------------------
	--- Section 04 : Lords & Heroes
	-------------------------------------------------
	
	local nts_lords_and_heroes = st_helper.navigable_tour_section_battle_factory(
		"lords_and_heroes",									-- section name
		nil,												-- camera positions generator
		nil,												-- advice key
		{
			"wh3_main_st_unit_types_0041",
			"wh3_main_st_unit_types_0042",
			"wh3_main_st_unit_types_0043",
			"wh3_main_st_unit_types_0044"
		},													-- infotext
		nil,												-- advice/infotext delay
		nil,												-- objective key
		nil,												-- objective completion test
		nil,												-- leave objective after completion
		"scripted_tours/unit_types/scripted_tour_heroes"	-- movie path
	);



	-------------------------------------------------
	--- Section 05 : Artillery
	-------------------------------------------------
	
	local nts_artillery = st_helper.navigable_tour_section_battle_factory(
		"artillery",										-- section name
		nil,												-- camera positions generator
		nil,												-- advice key
		{
			"wh3_main_st_unit_types_0051",
			"wh3_main_st_unit_types_0052",
			"wh3_main_st_unit_types_0053"
		},													-- infotext
		nil,												-- advice/infotext delay
		nil,												-- objective key
		nil,												-- objective completion test
		nil,												-- leave objective after completion
		"scripted_tours/unit_types/scripted_tour_artillery"	-- movie path
	);



	-------------------------------------------------
	--- Section 06 : Monsters
	-------------------------------------------------
	
	local nts_monsters = st_helper.navigable_tour_section_battle_factory(
		"monsters",											-- section name
		nil,												-- camera positions generator
		nil,												-- advice key
		{
			"wh3_main_st_unit_types_0061",
			"wh3_main_st_unit_types_0062",
			"wh3_main_st_unit_types_0063",
			"wh3_main_st_unit_types_0064"
		},													-- infotext
		nil,												-- advice/infotext delay
		nil,												-- objective key
		nil,												-- objective completion test
		nil,												-- leave objective after completion
		"scripted_tours/unit_types/scripted_tour_monsters"	-- movie path
	);



	-------------------------------------------------
	--- Section 07 : Flying Units
	-------------------------------------------------
	
	local nts_flying_units = st_helper.navigable_tour_section_battle_factory(
		"flying_units",										-- section name
		nil,												-- camera positions generator
		nil,												-- advice key
		{
			"wh3_main_st_unit_types_0071",
			"wh3_main_st_unit_types_0072",
			"wh3_main_st_unit_types_0073",
			"wh3_main_st_unit_types_0074"
		},													-- infotext
		nil,												-- advice/infotext delay
		nil,												-- objective key
		nil,												-- objective completion test
		nil,												-- leave objective after completion
		"scripted_tours/unit_types/scripted_tour_flying"	-- movie path
	);



	-- add all sections to tour in order
	nt_unit_types:add_navigable_section(nts_infantry);
	nt_unit_types:add_navigable_section(nts_mounted_units);
	nt_unit_types:add_navigable_section(nts_missile_units);
	nt_unit_types:add_navigable_section(nts_lords_and_heroes);
	nt_unit_types:add_navigable_section(nts_artillery);
	nt_unit_types:add_navigable_section(nts_monsters);
	nt_unit_types:add_navigable_section(nts_flying_units);

	

	-- add startup actions
	nt_unit_types:start_action(
		function()
			st_helper.setup_tour_start(nt_unit_types);
		end,
		0
	);


	-- add end actions
	nt_unit_types:end_action(
		function()
			st_helper.setup_tour_end(nt_unit_types);
		end
	);


end;