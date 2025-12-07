

--[[
-- for topic leader
require("script.battle.intro_battles.wh2_intro_battle");

-- helper functions
require("script.battle.scripted_tours.scripted_tour_helper_functions");
]]


local cam = bm:camera();
local campaign_key = bm:get_campaign_key();
local infotext = get_infotext_manager();
local ui_root = core:get_ui_root();

local sunits_local_player = bm:get_scriptunits_for_local_players_army();







-- Infotext state overrides
infotext:set_state_override("wh3_main_st_siege_battles_0013", "prelude_normal_bullet_text");
infotext:set_state_override("wh3_main_st_siege_battles_0014", "prelude_normal_bullet_text");
infotext:set_state_override("wh3_main_st_siege_battles_0015", "prelude_normal_bullet_end");









-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
-- MAJOR SIEGE BATTLE DEFENCE
-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
do	
	nt_siege_defence = navigable_tour:new(
		"siege_battle_defence",														-- unique name
		function()																	-- end callback
		end,
		"ui_text_replacements_localised_text_wh3_main_battle_scripted_tour_major_siege_defence_name"
	);

	nt_siege_defence:set_allow_camera_movement(true);

	-- validation rules for this navigable tour
	nt_siege_defence:add_validation_rule(
		function()
			return core:is_battle()
		end,
		"random_localisation_strings_string_scripted_tour_invalid_not_battle"
	);

	nt_siege_defence:add_validation_rule(
		function()
			return not bm:is_multiplayer()
		end,
		"random_localisation_strings_string_scripted_tour_invalid_not_singleplayer"
	);

	nt_siege_defence:add_validation_rule(
		function()
			return bm:battle_type() == "settlement_standard"
		end,
		"random_localisation_strings_string_scripted_tour_invalid_not_major_siege_battle"
	);

	nt_siege_defence:add_validation_rule(
		function()
			return not bm:player_is_attacker()
		end,
		"random_localisation_strings_string_scripted_tour_invalid_player_not_defender"
	);

	nt_siege_defence:add_validation_rule(
		function()
			return bm:get_current_phase_name() == "Deployment"
		end,
		"random_localisation_strings_string_scripted_tour_invalid_player_not_deployment"
	);

	nt_siege_defence:add_validation_context_change_listener(
		"BattleConflictPhaseCommenced"
	);
	






	-------------------------------------------------
	--- Section 01 : Intro
	-------------------------------------------------

	local nts_intro = st_helper.navigable_tour_section_battle_factory(
		"intro",											-- section name
		function() 
			return st_helper.get_offset_camera_positions_for_siege_defence_start();
		end,												-- camera positions generator
		nil,												-- advice key
		{
			"wh3_main_st_siege_battles_0001",
			"wh3_main_st_siege_battles_0002",
			"wh3_main_st_siege_battles_0003"
		}													-- infotext
	);

	-- precondition(s)
	nts_intro:add_precondition(
		function()
			return not not bm:get_scriptunits_for_local_players_army():get_general_sunit();
		end,
		"No player general could be found - how can this be?"
	);


	

	-------------------------------------------------
	--- Section 02 : Walls
	-------------------------------------------------

	local nts_walls = st_helper.navigable_tour_section_battle_factory(
		"walls",											-- section name
		function() 
			return st_helper.get_offset_camera_positions_from_walls_as_defender()
		end,												-- camera positions generator
		nil,												-- advice key
		{
			"wh3_main_st_siege_battles_0010",
			"wh3_main_st_siege_battles_0011",
			"wh3_main_st_siege_battles_0012",
			"wh3_main_st_siege_battles_0013",
			"wh3_main_st_siege_battles_0014",
			"wh3_main_st_siege_battles_0015",
			"wh3_main_st_siege_battles_0016"
		}													-- infotext
	);

	-- precondition(s)
	nts_walls:add_precondition(
		function()
			return st_helper.fort_wall_building_exists();
		end,
		"No valid wall pieces could be found"
	);




	-------------------------------------------------
	--- Section 03 : Gates
	-------------------------------------------------

	local nts_gates = st_helper.navigable_tour_section_battle_factory(
		"gates",											-- section name
		function() 
			return st_helper.get_offset_camera_positions_from_gate(false)
		end,												-- camera positions generator
		nil,												-- advice key
		{
			"wh3_main_st_siege_battles_0020",
			"wh3_main_st_siege_battles_0021",
			"wh3_main_st_siege_battles_0022",
			"wh3_main_st_siege_battles_0023"
		}													-- infotext
	);

	-- precondition(s)
	nts_gates:add_precondition(
		function()
			return st_helper.fort_gate_building_exists();
		end,
		"No gates could be found"
	);



	
	-------------------------------------------------
	--- Section 04 : Towers
	-------------------------------------------------

	local nts_towers = st_helper.navigable_tour_section_battle_factory(
		"towers",											-- section name
		function() 
			return st_helper.get_offset_camera_positions_from_tower()
		end,												-- camera positions generator
		nil,												-- advice key
		{
			"wh3_main_st_siege_battles_0030",
			"wh3_main_st_siege_battles_0031",
			"wh3_main_st_siege_battles_0032",
			"wh3_main_st_siege_battles_0033"
		}													-- infotext
	);

	-- precondition(s)
	nts_towers:add_precondition(
		function()
			return st_helper.selectable_tower_exists();
		end,
		"No suitable tower could be found"
	);
	


	
	-------------------------------------------------
	--- Section 05 : Capture Locations
	-------------------------------------------------

	local nts_capture_locations_capture_location_str;
	local nts_capture_locations = st_helper.navigable_tour_section_battle_factory(
		"capture_locations",								-- section name
		function()
			local pos_capture_location, start_cam_position, end_cam_position, capture_location_str = st_helper.get_offset_camera_positions_from_gate_capture_location();
			nts_capture_locations_capture_location_str = capture_location_str;
			return pos_capture_location, start_cam_position, end_cam_position;
		end,												-- camera positions generator
		nil,												-- advice key
		{
			"wh3_main_st_siege_battles_0040",
			"wh3_main_st_siege_battles_0041",
			"wh3_main_st_siege_battles_0042",
			"wh3_main_st_siege_battles_0043",
			"wh3_main_st_siege_battles_0044"
		}													-- infotext
	);

	-- precondition(s)
	nts_capture_locations:add_precondition(
		function()
			return st_helper.capture_location_with_gate_exists();
		end,
		"No gates with capture locations could be found"
	);


	-- additional action(s)
	nts_capture_locations:action(
		function()
			if is_string(nts_capture_locations_capture_location_str) then
				common.call_context_command("CcoBattleRoot", "", nts_capture_locations_capture_location_str .. ".SetHighlight(true)");

				nts_capture_locations:add_skip_action(
					function()
						if is_string(nts_capture_locations_capture_location_str) then
							common.call_context_command("CcoBattleRoot", "", nts_capture_locations_capture_location_str .. ".SetHighlight(false)");
						end;
					end
				);
			end;
		end,
		3000
	);


	
	-------------------------------------------------
	--- Section 06 : Enemy Siege Weapons
	-------------------------------------------------

	local nts_enemy_siege_weapons = st_helper.navigable_tour_section_battle_factory(
		"enemy_siege_weapons",								-- section name
		function() 
			return st_helper.get_offset_camera_positions_from_siege_weapons();
		end,												-- camera positions generator
		nil,												-- advice key
		{
			"wh3_main_st_siege_battles_0050",
			"wh3_main_st_siege_battles_0051",
			"wh3_main_st_siege_battles_0052"
		}													-- infotext
	);

	-- precondition(s)
	nts_enemy_siege_weapons:add_precondition(
		function()
			return bm:assault_equipment_exists();
		end
	);

	

	
	-------------------------------------------------
	--- Section 07 : Constructed Defences
	-------------------------------------------------

	local nts_constructed_defences = st_helper.navigable_tour_section_battle_factory(
		"constructed_defences",								-- section name
		function() 
			return st_helper.get_offset_camera_positions_from_minor_point_supplies_toggleable_slot_location();
		end,												-- camera positions generator
		nil,												-- advice key
		{
			"wh3_main_st_siege_battles_0060",
			"wh3_main_st_siege_battles_0062",
			"wh3_main_st_siege_battles_0063",
			"wh3_main_st_siege_battles_0064"
		}													-- infotext
	);

	-- precondition(s)
	nts_constructed_defences:add_precondition(
		function()
			return st_helper.minor_supply_capture_location_with_toggleable_slot_exists();
		end,
		"No toggleable slots could be found"
	);

	-- additional action(s)
	nts_constructed_defences:action(
		function()
			local ap = active_pointer:new(
				"siege_resources",
				"topright",
				find_uicomponent(core:get_ui_root(), "hud_battle", "BOP_frame", "supplies_display"),
				"ui_text_replacements_localised_text_ap_battle_siege_resources",
				0.5,
				1,
				false,
				true
			);
			ap:show();
		end,
		3500
	);

	

			




	-------------------------------------------------
	--- Section 08 : Supply Locations
	-------------------------------------------------

	local nts_supply_locations = st_helper.navigable_tour_section_battle_factory(
		"supply_locations",									-- section name
		function() 
			return st_helper.get_offset_camera_positions_from_minor_point_supplies_capture_location();
		end,												-- camera positions generator
		nil,												-- advice key
		{
			"wh3_main_st_siege_battles_0070",
			"wh3_main_st_siege_battles_0071",
			"wh3_main_st_siege_battles_0072",
			"wh3_main_st_siege_battles_0073",
			"wh3_main_st_siege_battles_0074"
		}													-- infotext
	);

	-- precondition(s)
	nts_supply_locations:add_precondition(
		function()
			return st_helper.minor_supply_capture_location_exists();
		end,
		"No supply locations could be found"
	);

	-- additional action(s)
	nts_supply_locations:action(
		function()
			local ap = active_pointer:new(
				"siege_resources",
				"topright",
				find_uicomponent(core:get_ui_root(), "hud_battle", "BOP_frame", "supplies_display"),
				"ui_text_replacements_localised_text_ap_battle_siege_resources_tooltip",
				0.5,
				1,
				false,
				true
			);
			ap:show();
		end,
		3500
	);





	-------------------------------------------------
	--- Section 09 : Major Victory Locations
	-------------------------------------------------

	local nts_major_victory_locations = st_helper.navigable_tour_section_battle_factory(
		"major_victory_locations",							-- section name
		function() 
			return st_helper.get_offset_camera_positions_from_major_victory_point();
		end,												-- camera positions generator
		nil,												-- advice key
		{
			"wh3_main_st_siege_battles_0080",
			"wh3_main_st_siege_battles_0081",
			"wh3_main_st_siege_battles_0082",
			"wh3_main_st_siege_battles_0083"
		}													-- infotext
	);

	-- precondition(s)
	nts_major_victory_locations:add_precondition(
		function()
			return st_helper.victory_point_plaza_capture_location_exists();
		end,
		"No major victory locations could be found"
	);

	-- additional action(s)
	nts_major_victory_locations:action(
		function()
			local ap = active_pointer:new(
				"siege_resources",
				"topleft",
				find_uicomponent(core:get_ui_root(), "hud_battle", "BOP_frame", "siege_victory_bar_holder"),
				"ui_text_replacements_localised_text_ap_battle_siege_attacker_victory_bar",
				0.5,
				1,
				false,
				true
			);
			ap:show();
		end,
		3500
	);




	-------------------------------------------------
	--- Section 10 : Minor Victory Locations
	-------------------------------------------------

	local nts_minor_victory_locations = st_helper.navigable_tour_section_battle_factory(
		"minor_victory_locations",							-- section name
		function() 
			return st_helper.get_offset_camera_positions_from_minor_victory_point();
		end,												-- camera positions generator
		nil,												-- advice key
		{
			"wh3_main_st_siege_battles_0085",
			"wh3_main_st_siege_battles_0086",
			"wh3_main_st_siege_battles_0087",
			"wh3_main_st_siege_battles_0088"
		}													-- infotext
	);

	-- precondition(s)
	nts_minor_victory_locations:add_precondition(
		function()
			return st_helper.major_key_building_capture_location_exists();
		end,
		"No major victory locations could be found"
	);


	-- add all sections to tour in order
	nt_siege_defence:add_navigable_section(nts_intro);
	nt_siege_defence:add_navigable_section(nts_walls);
	nt_siege_defence:add_navigable_section(nts_gates);
	nt_siege_defence:add_navigable_section(nts_towers);
	nt_siege_defence:add_navigable_section(nts_capture_locations);
	nt_siege_defence:add_navigable_section(nts_enemy_siege_weapons);
	nt_siege_defence:add_navigable_section(nts_constructed_defences);
	nt_siege_defence:add_navigable_section(nts_supply_locations);
	nt_siege_defence:add_navigable_section(nts_major_victory_locations);
	nt_siege_defence:add_navigable_section(nts_minor_victory_locations);


	-- add startup actions
	nt_siege_defence:start_action(
		function()
			st_helper.setup_tour_start(nt_siege_defence);
		end,
		0
	);


	-- add end actions
	nt_siege_defence:end_action(
		function()
			st_helper.setup_tour_end(nt_siege_defence);
		end
	);
end;



































-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
-- MAJOR SIEGE BATTLE ATTACK
-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
do
	nt_siege_battle_attack = navigable_tour:new(
		"siege_battle_attack",														-- unique name
		function()																	-- end callback
		end,
		"ui_text_replacements_localised_text_wh3_main_battle_scripted_tour_major_siege_attack_name"
	);

	nt_siege_battle_attack:set_allow_camera_movement(true);

	-- validation rules for this navigable tour
	nt_siege_battle_attack:add_validation_rule(
		function()
			return core:is_battle()
		end,
		"random_localisation_strings_string_scripted_tour_invalid_not_battle"
	);

	nt_siege_battle_attack:add_validation_rule(
		function()
			return not bm:is_multiplayer()
		end,
		"random_localisation_strings_string_scripted_tour_invalid_not_singleplayer"
	);

	nt_siege_battle_attack:add_validation_rule(
		function()
			return bm:battle_type() == "settlement_standard"
		end,
		"random_localisation_strings_string_scripted_tour_invalid_not_major_siege_battle"
	);

	nt_siege_battle_attack:add_validation_rule(
		function()
			return bm:player_is_attacker()
		end,
		"random_localisation_strings_string_scripted_tour_invalid_player_not_attacker"
	);

	nt_siege_battle_attack:add_validation_rule(
		function()
			return bm:get_current_phase_name() == "Deployment"
		end,
		"random_localisation_strings_string_scripted_tour_invalid_player_not_deployment"
	);

	nt_siege_battle_attack:add_validation_context_change_listener(
		"BattleConflictPhaseCommenced"
	);






	-------------------------------------------------
	--- Section 01 : Intro
	-------------------------------------------------
	
	local nts_intro = st_helper.navigable_tour_section_battle_factory(
		"intro",											-- section name
		function() 
			return st_helper.get_offset_camera_positions_from_sunits(
				sunits_local_player, 
				0, 
				-100,
				nil,
				nil,
				nil,
				true
			);
		end,												-- camera positions generator
		nil,												-- advice key
		{
			"wh3_main_st_siege_battles_0001",
			"wh3_main_st_siege_battles_0002",
			"wh3_main_st_siege_battles_0003"
		}													-- infotext
	);





	-------------------------------------------------
	--- Section 02 : Siege Weapons
	-------------------------------------------------
	
	local nts_siege_weapons = st_helper.navigable_tour_section_battle_factory(
		"siege_weapons",									-- section name
		function() 
			return st_helper.get_offset_camera_positions_from_siege_weapons()
		end,												-- camera positions generator
		nil,												-- advice key
		{
			"wh3_main_st_siege_battles_0050",
			"wh3_main_st_siege_battles_0051",
			"wh3_main_st_siege_battles_0052",
			"wh3_main_st_siege_battles_0053"
		}													-- infotext
	);

	-- precondition(s)
	nts_siege_weapons:add_precondition(
		function()
			return bm:assault_equipment_exists();
		end
	);




	-------------------------------------------------
	--- Section 03 : Walls
	-------------------------------------------------

	local nts_walls = st_helper.navigable_tour_section_battle_factory(
		"walls",											-- section name
		function() 
			return st_helper.get_offset_camera_positions_from_walls_as_attacker()
		end,												-- camera positions generator
		nil,												-- advice key
		{
			"wh3_main_st_siege_battles_0010",
			"wh3_main_st_siege_battles_0011",
			"wh3_main_st_siege_battles_0012",
			"wh3_main_st_siege_battles_0013",
			"wh3_main_st_siege_battles_0014",
			"wh3_main_st_siege_battles_0015",
			"wh3_main_st_siege_battles_0016"
		}													-- infotext
	);

	-- precondition(s)
	nts_walls:add_precondition(
		function()
			return st_helper.fort_wall_building_exists();
		end,
		"No valid wall pieces could be found"
	);



	
	-------------------------------------------------
	--- Section 04 : Gates
	-------------------------------------------------

	local nts_gates = st_helper.navigable_tour_section_battle_factory(
		"gates",											-- section name
		function() 
			return st_helper.get_offset_camera_positions_from_gate(true)
		end,												-- camera positions generator
		nil,												-- advice key
		{
			"wh3_main_st_siege_battles_0020",
			"wh3_main_st_siege_battles_0021",
			"wh3_main_st_siege_battles_0022",
			"wh3_main_st_siege_battles_0023"
		}													-- infotext
	);

	-- precondition(s)
	nts_gates:add_precondition(
		function()
			return st_helper.fort_gate_building_exists();
		end,
		"No gates could be found"
	);




	-------------------------------------------------
	--- Section 05 : Towers
	-------------------------------------------------

	local nts_towers = st_helper.navigable_tour_section_battle_factory(
		"towers",											-- section name
		function() 
			return st_helper.get_offset_camera_positions_from_tower()
		end,												-- camera positions generator
		nil,												-- advice key
		{
			"wh3_main_st_siege_battles_0030",
			"wh3_main_st_siege_battles_0031",
			"wh3_main_st_siege_battles_0032",
			"wh3_main_st_siege_battles_0033"
		}													-- infotext
	);

	-- precondition(s)
	nts_towers:add_precondition(
		function()
			return st_helper.selectable_tower_exists();
		end,
		"No suitable tower could be found"
	);
	


	
	-------------------------------------------------
	--- Section 06 : Capture Locations
	-------------------------------------------------

	local nts_capture_locations_capture_location_str;
	local nts_capture_locations = st_helper.navigable_tour_section_battle_factory(
		"capture_locations",								-- section name
		function()
			local pos_capture_location, start_cam_position, end_cam_position, capture_location_str = st_helper.get_offset_camera_positions_from_gate_capture_location();
			nts_capture_locations_capture_location_str = capture_location_str;
			return pos_capture_location, start_cam_position, end_cam_position;
		end,												-- camera positions generator
		nil,												-- advice key
		{
			"wh3_main_st_siege_battles_0040",
			"wh3_main_st_siege_battles_0041",
			"wh3_main_st_siege_battles_0042",
			"wh3_main_st_siege_battles_0043",
			"wh3_main_st_siege_battles_0044"
		}													-- infotext
	);

	-- precondition(s)
	nts_capture_locations:add_precondition(
		function()
			return st_helper.capture_location_with_gate_exists();
		end,
		"No gates with capture locations could be found"
	);

	-- additional action(s)
	nts_capture_locations:action(
		function()
			if is_string(nts_capture_locations_capture_location_str) then
				common.call_context_command("CcoBattleRoot", "", nts_capture_locations_capture_location_str .. ".SetHighlight(true)");

				nts_capture_locations:add_skip_action(
					function()
						if is_string(nts_capture_locations_capture_location_str) then
							common.call_context_command("CcoBattleRoot", "", nts_capture_locations_capture_location_str .. ".SetHighlight(false)");
						end;
					end
				);
			end;
		end,
		3000
	);

	

	
	-------------------------------------------------
	--- Section 07 : Constructed Defences
	-------------------------------------------------

	local nts_constructed_defences = st_helper.navigable_tour_section_battle_factory(
		"constructed_defences",								-- section name
		function() 
			return st_helper.get_offset_camera_positions_from_minor_point_supplies_capture_location();
		end,												-- camera positions generator
		nil,												-- advice key
		{
			"wh3_main_st_siege_battles_0060",
			"wh3_main_st_siege_battles_0061",
			"wh3_main_st_siege_battles_0063",
			"wh3_main_st_siege_battles_0064",
		}													-- infotext
	);

	-- precondition(s)
	nts_constructed_defences:add_precondition(
		function()
			return st_helper.minor_supply_capture_location_exists();
		end,
		"No supply locations could be found"
	);

	-- additional action(s)
	nts_constructed_defences:action(
		function()
			local uic_icon_parent = find_uicomponent(core:get_ui_root(), "hud_battle", "BOP_frame", "docked_holder", "icon_parent");

			if not uic_icon_parent then
				script_error("WARNING: nts_constructed_defences could not find uic_icon_parent - active pointer will not be displayed");
				return;
			end;

			local uic_target;
			for i = 0, uic_icon_parent:ChildCount() - 1 do
				local uic_child = UIComponent(uic_icon_parent:Find(i));
				if uic_child:Visible(true) then
					uic_target = uic_child;
					break;
				end;
			end;

			if uic_target then
				local ap = active_pointer:new(
					"capture_location_icons",
					"topleft",
					uic_target,
					"ui_text_replacements_localised_text_ap_battle_capture_location_icons",
					0.5,
					1,
					false,
					true
				);
				ap:show();
			end;
		end,
		3500
	);





	-------------------------------------------------
	--- Section 08 : Major Victory Locations
	-------------------------------------------------

	local nts_major_victory_locations = st_helper.navigable_tour_section_battle_factory(
		"major_victory_locations",							-- section name
		function() 
			return st_helper.get_offset_camera_positions_from_major_victory_point();
		end,												-- camera positions generator
		nil,												-- advice key
		{
			"wh3_main_st_siege_battles_0080",
			"wh3_main_st_siege_battles_0081",
			"wh3_main_st_siege_battles_0082",
			"wh3_main_st_siege_battles_0083"

		}													-- infotext
	);

	-- precondition(s)
	nts_major_victory_locations:add_precondition(
		function()
			return st_helper.victory_point_plaza_capture_location_exists();
		end,
		"No major victory locations could be found"
	);

	-- additional action(s)
	nts_major_victory_locations:action(
		function()
			local ap = active_pointer:new(
				"siege_resources",
				"topleft",
				find_uicomponent(core:get_ui_root(), "hud_battle", "BOP_frame", "siege_victory_bar_holder"),
				"ui_text_replacements_localised_text_ap_battle_siege_attacker_victory_bar",
				0.5,
				1,
				false,
				true
			);
			ap:show();
		end,
		3500
	);




	-------------------------------------------------
	--- Section 09 : Minor Victory Locations
	-------------------------------------------------

	local nts_minor_victory_locations = st_helper.navigable_tour_section_battle_factory(
		"minor_victory_locations",							-- section name
		function() 
			return st_helper.get_offset_camera_positions_from_minor_victory_point();
		end,												-- camera positions generator
		nil,												-- advice key
		{
			"wh3_main_st_siege_battles_0085",
			"wh3_main_st_siege_battles_0086",
			"wh3_main_st_siege_battles_0087",
			"wh3_main_st_siege_battles_0088"
		}													-- infotext
	);

	-- precondition(s)
	nts_minor_victory_locations:add_precondition(
		function()
			return st_helper.major_key_building_capture_location_exists();
		end,
		"No major victory locations could be found"
	);


	-- add all sections to tour in order
	nt_siege_battle_attack:add_navigable_section(nts_intro);
	nt_siege_battle_attack:add_navigable_section(nts_siege_weapons);
	nt_siege_battle_attack:add_navigable_section(nts_walls);
	nt_siege_battle_attack:add_navigable_section(nts_gates);
	nt_siege_battle_attack:add_navigable_section(nts_towers);
	nt_siege_battle_attack:add_navigable_section(nts_capture_locations);
	nt_siege_battle_attack:add_navigable_section(nts_constructed_defences);
	nt_siege_battle_attack:add_navigable_section(nts_major_victory_locations);
	nt_siege_battle_attack:add_navigable_section(nts_minor_victory_locations);


	
	-- add startup actions
	nt_siege_battle_attack:start_action(
		function()
			st_helper.setup_tour_start(nt_siege_battle_attack);
		end,
		0
	);


	-- add end actions
	nt_siege_battle_attack:end_action(
		function()
			st_helper.setup_tour_end(nt_siege_battle_attack);
		end
	);
end;































-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
-- MINOR SETTLEMENT BATTLE DEFENCE
-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
do
	nt_minor_settlement_defence = navigable_tour:new(
		"minor_settlement_defence",														-- unique name
		function()																		-- end callback
		end,
		"ui_text_replacements_localised_text_wh3_main_battle_scripted_tour_minor_settlement_defence_name"
	);

	nt_minor_settlement_defence:set_allow_camera_movement(true);

	-- validation rules for this navigable tour
	nt_minor_settlement_defence:add_validation_rule(
		function()
			return core:is_battle()
		end,
		"random_localisation_strings_string_scripted_tour_invalid_not_battle"
	);

	nt_minor_settlement_defence:add_validation_rule(
		function()
			return not bm:is_multiplayer()
		end,
		"random_localisation_strings_string_scripted_tour_invalid_not_singleplayer"
	);

	nt_minor_settlement_defence:add_validation_rule(
		function()
			return bm:battle_type() == "settlement_unfortified"
		end,
		"random_localisation_strings_string_scripted_tour_invalid_not_major_siege_battle"
	);

	nt_minor_settlement_defence:add_validation_rule(
		function()
			return not bm:player_is_attacker()
		end,
		"random_localisation_strings_string_scripted_tour_invalid_player_not_defender"
	);

	nt_minor_settlement_defence:add_validation_rule(
		function()
			return bm:get_current_phase_name() == "Deployment"
		end,
		"random_localisation_strings_string_scripted_tour_invalid_player_not_deployment"
	);

	nt_minor_settlement_defence:add_validation_context_change_listener(
		"BattleConflictPhaseCommenced"
	);






	-------------------------------------------------
	--- Section 01 : Intro
	-------------------------------------------------
	
	local nts_intro = st_helper.navigable_tour_section_battle_factory(
		"intro",											-- section name
		function() 
			local sunit_player_general = bm:get_scriptunits_for_local_players_army():get_general_sunit();
			return st_helper.get_offset_camera_positions_from_sunit(sunit_player_general, 0, -100);
		end,												-- camera positions generator
		nil,												-- advice key
		{
			"wh3_main_st_siege_battles_0090",
			"wh3_main_st_siege_battles_0091",
			"wh3_main_st_siege_battles_0092",
			"wh3_main_st_siege_battles_0093"
		}													-- infotext
	);

	-- precondition(s)
	nts_intro:add_precondition(
		function()
			return not not bm:get_scriptunits_for_local_players_army():get_general_sunit();
		end,
		"No player general could be found - how can this be?"
	);


	



	-------------------------------------------------
	--- Section 02 : Constructed Defences
	-------------------------------------------------

	local nts_constructed_defences = st_helper.navigable_tour_section_battle_factory(
		"constructed_defences",								-- section name
		function() 
			return st_helper.get_offset_camera_positions_from_minor_point_supplies_toggleable_slot_location();
		end,												-- camera positions generator
		nil,												-- advice key
		{
			"wh3_main_st_siege_battles_0060",
			"wh3_main_st_siege_battles_0062",
			"wh3_main_st_siege_battles_0063",
			"wh3_main_st_siege_battles_0064"
		}													-- infotext
	);

	-- precondition(s)
	nts_constructed_defences:add_precondition(
		function()
			return st_helper.minor_supply_capture_location_with_toggleable_slot_exists();
		end,
		"No toggleable slots could be found"
	);

	-- additional action(s)
	nts_constructed_defences:action(
		function()
			local ap = active_pointer:new(
				"siege_resources",
				"topright",
				find_uicomponent(core:get_ui_root(), "hud_battle", "BOP_frame", "supplies_display"),
				"ui_text_replacements_localised_text_ap_battle_siege_resources",
				0.5,
				1,
				false,
				true
			);
			ap:show();
		end,
		3500
	);

	

	


	-------------------------------------------------
	--- Section 03 : Supply Locations
	-------------------------------------------------

	local nts_supply_locations = st_helper.navigable_tour_section_battle_factory(
		"supply_locations",									-- section name
		function() 
			return st_helper.get_offset_camera_positions_from_minor_point_supplies_capture_location();
		end,												-- camera positions generator
		nil,												-- advice key
		{
			"wh3_main_st_siege_battles_0070",
			"wh3_main_st_siege_battles_0071",
			"wh3_main_st_siege_battles_0072",
			"wh3_main_st_siege_battles_0073",
			"wh3_main_st_siege_battles_0074"
		}													-- infotext
	);

	-- precondition(s)
	nts_supply_locations:add_precondition(
		function()
			return st_helper.minor_supply_capture_location_exists();
		end,
		"No supply locations could be found"
	);

	-- additional action(s)
	nts_supply_locations:action(
		function()
			local ap = active_pointer:new(
				"siege_resources",
				"topright",
				find_uicomponent(core:get_ui_root(), "hud_battle", "BOP_frame", "supplies_display"),
				"ui_text_replacements_localised_text_ap_battle_siege_resources_tooltip",
				0.5,
				1,
				false,
				true
			);
			ap:show();
		end,
		3500
	);






	-------------------------------------------------
	--- Section 04 : Capture Locations
	-------------------------------------------------

	local nts_capture_locations_capture_location_str;
	local nts_capture_locations = st_helper.navigable_tour_section_battle_factory(
		"capture_locations",								-- section name
		function()
			local pos_capture_location, start_cam_position, end_cam_position, capture_location_str = st_helper.get_offset_camera_positions_from_capture_location();
			nts_capture_locations_capture_location_str = capture_location_str;
			return pos_capture_location, start_cam_position, end_cam_position;
		end,												-- camera positions generator
		nil,												-- advice key
		{
			"wh3_main_st_siege_battles_0040",
			"wh3_main_st_siege_battles_0041",
			"wh3_main_st_siege_battles_0042",
			"wh3_main_st_siege_battles_0043",
			"wh3_main_st_siege_battles_0044"
		}													-- infotext
	);

	-- precondition(s)
	nts_capture_locations:add_precondition(
		function()
			return st_helper.capture_location_exists();
		end,
		"No capture locations found"
	);


	-- additional action(s)
	nts_capture_locations:action(
		function()
			if is_string(nts_capture_locations_capture_location_str) then
				common.call_context_command("CcoBattleRoot", "", nts_capture_locations_capture_location_str .. ".SetHighlight(true)");

				nts_capture_locations:add_skip_action(
					function()
						if is_string(nts_capture_locations_capture_location_str) then
							common.call_context_command("CcoBattleRoot", "", nts_capture_locations_capture_location_str .. ".SetHighlight(false)");
						end;
					end
				);
			end;
		end,
		3000
	);







	-- add all sections to tour in order
	nt_minor_settlement_defence:add_navigable_section(nts_intro);
	nt_minor_settlement_defence:add_navigable_section(nts_constructed_defences);
	nt_minor_settlement_defence:add_navigable_section(nts_supply_locations);
	nt_minor_settlement_defence:add_navigable_section(nts_capture_locations);
	


	
	-- add startup actions
	nt_minor_settlement_defence:start_action(
		function()
			if	bm:get_current_phase_name() == "Deployment" then 
				st_helper.setup_tour_start(nt_minor_settlement_defence);
			end
		end,
		0
	);


	-- add end actions
	nt_minor_settlement_defence:end_action(
		function()
			st_helper.setup_tour_end(nt_minor_settlement_defence);
		end
	);
end;
































-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
-- MINOR SETTLEMENT BATTLE ATTACK
-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
do
	nt_minor_settlement_attack = navigable_tour:new(
		"minor_settlement_attack",														-- unique name
		function()																		-- end callback
		end,
		"ui_text_replacements_localised_text_wh3_main_battle_scripted_tour_minor_settlement_attack_name"
	);

	nt_minor_settlement_attack:set_allow_camera_movement(true);

	-- validation rules for this navigable tour
	nt_minor_settlement_attack:add_validation_rule(
		function()
			return core:is_battle()
		end,
		"random_localisation_strings_string_scripted_tour_invalid_not_battle"
	);

	nt_minor_settlement_attack:add_validation_rule(
		function()
			return not bm:is_multiplayer()
		end,
		"random_localisation_strings_string_scripted_tour_invalid_not_singleplayer"
	);

	nt_minor_settlement_attack:add_validation_rule(
		function()
			return bm:battle_type() == "settlement_unfortified"
		end,
		"random_localisation_strings_string_scripted_tour_invalid_not_major_siege_battle"
	);

	nt_minor_settlement_attack:add_validation_rule(
		function()
			return bm:player_is_attacker()
		end,
		"random_localisation_strings_string_scripted_tour_invalid_player_not_attacker"
	);

	nt_minor_settlement_attack:add_validation_rule(
		function()
			return bm:get_current_phase_name() == "Deployment"
		end,
		"random_localisation_strings_string_scripted_tour_invalid_player_not_deployment"
	);

	nt_minor_settlement_attack:add_validation_context_change_listener(
		"BattleConflictPhaseCommenced"
	);






	-------------------------------------------------
	--- Section 01 : Intro
	-------------------------------------------------
	
	local nts_intro = st_helper.navigable_tour_section_battle_factory(
		"intro",											-- section name
		function() 
			local sunit_player_general = bm:get_scriptunits_for_local_players_army():get_general_sunit();
			return st_helper.get_offset_camera_positions_from_sunit(sunit_player_general, 0, -100);
		end,												-- camera positions generator
		nil,												-- advice key
		{
			"wh3_main_st_siege_battles_0090",
			"wh3_main_st_siege_battles_0091",
			"wh3_main_st_siege_battles_0092",
			"wh3_main_st_siege_battles_0093"
		}													-- infotext		
	);

	-- precondition(s)
	nts_intro:add_precondition(
		function()
			return not not bm:get_scriptunits_for_local_players_army():get_general_sunit();
		end,
		"No player general could be found - how can this be?"
	);


	



	-------------------------------------------------
	--- Section 02 : Constructed Defences
	-------------------------------------------------

	local nts_constructed_defences = st_helper.navigable_tour_section_battle_factory(
		"constructed_defences",								-- section name
		function() 
			return st_helper.get_offset_camera_positions_from_minor_point_supplies_capture_location();
		end,												-- camera positions generator
		nil,												-- advice key
		{
			"wh3_main_st_siege_battles_0060",
			"wh3_main_st_siege_battles_0061",
			"wh3_main_st_siege_battles_0063",
			"wh3_main_st_siege_battles_0064"
		}													-- infotext
	);

	-- precondition(s)
	nts_constructed_defences:add_precondition(
		function()
			return st_helper.minor_supply_capture_location_exists();
		end,
		"No toggleable slots could be found"
	);

	-- additional action(s)
	nts_constructed_defences:action(
		function()
			local uic_icon_parent = find_uicomponent(core:get_ui_root(), "hud_battle", "BOP_frame", "docked_holder", "icon_parent");

			if not uic_icon_parent then
				script_error("WARNING: nts_constructed_defences could not find uic_icon_parent - active pointer will not be displayed");
				return;
			end;

			local uic_target;
			for i = 0, uic_icon_parent:ChildCount() - 1 do
				local uic_child = UIComponent(uic_icon_parent:Find(i));
				if uic_child:Visible(true) then
					uic_target = uic_child;
					break;
				end;
			end;

			if uic_target then
				local ap = active_pointer:new(
					"capture_location_icons",
					"topleft",
					uic_target,
					"ui_text_replacements_localised_text_ap_battle_capture_location_icons",
					0.5,
					1,
					false,
					true
				);
				ap:show();
			end;
		end,
		3500
	);





	-------------------------------------------------
	--- Section 03 : Capture Locations
	-------------------------------------------------

	local nts_capture_locations_capture_location_str;
	local nts_capture_locations = st_helper.navigable_tour_section_battle_factory(
		"capture_locations",								-- section name
		function()
			local pos_capture_location, start_cam_position, end_cam_position, capture_location_str = st_helper.get_offset_camera_positions_from_capture_location();
			nts_capture_locations_capture_location_str = capture_location_str;
			return pos_capture_location, start_cam_position, end_cam_position;
		end,												-- camera positions generator
		nil,												-- advice key
		{
			"wh3_main_st_siege_battles_0040",
			"wh3_main_st_siege_battles_0041",
			"wh3_main_st_siege_battles_0042",
			"wh3_main_st_siege_battles_0043",
			"wh3_main_st_siege_battles_0044"
		}													-- infotext
	);

	-- precondition(s)
	nts_capture_locations:add_precondition(
		function()
			return st_helper.capture_location_exists();
		end,
		"No capture locations found"
	);


	-- additional action(s)
	nts_capture_locations:action(
		function()
			if is_string(nts_capture_locations_capture_location_str) then
				common.call_context_command("CcoBattleRoot", "", nts_capture_locations_capture_location_str .. ".SetHighlight(true)");

				nts_capture_locations:add_skip_action(
					function()
						if is_string(nts_capture_locations_capture_location_str) then
							common.call_context_command("CcoBattleRoot", "", nts_capture_locations_capture_location_str .. ".SetHighlight(false)");
						end;
					end
				);
			end;
		end,
		3000
	);




	



	-- add all sections to tour in order
	nt_minor_settlement_attack:add_navigable_section(nts_intro);
	nt_minor_settlement_attack:add_navigable_section(nts_constructed_defences);
	nt_minor_settlement_attack:add_navigable_section(nts_capture_locations);
	


	
	-- add startup actions
	nt_minor_settlement_attack:start_action(
		function()
			if	bm:get_current_phase_name() == "Deployment" then 
				st_helper.setup_tour_start(nt_minor_settlement_attack);
			end 
		end,
		0
	);


	-- add end actions
	nt_minor_settlement_attack:end_action(
		function()
			-- Re-enable orders
			bm:disable_orders(false);

			-- Re-enable grouping/formations
			bm:disable_groups(false);
			bm:disable_formations(false);

			-- Re-attach infotext to advisor
			bm:attach_to_advisor(true);

			-- Re-enable bits of the UI we didn't want
			bm:disable_help_page_button(false);
			bm:disable_tactical_map(false);
			bm:disable_unit_camera(false);
			bm:disable_unit_details_panel(false);
			bm:show_top_bar(true);
			bm:show_army_panel(true);
			bm:show_radar_frame(true);
			bm:show_army_abilities(true);
			bm:show_ui_options_panel(true);
			bm:enable_spell_browser_button(true);
			bm:show_winds_of_magic_panel(true);
			bm:show_portrait_panel(true);

			core:restore_integer_preference("ui_leaf_clipping");
			core:restore_boolean_preference("ui_mouse_scroll");
			core:restore_integer_preference("ui_selection_markers");
			core:restore_integer_preference("ui_unit_select_outlines");

			local hpm = get_help_page_manager();
			hpm:show_title_bar_buttons(true);
			hpm:hide_panel();
			hpm:related_panel_closed("float_top_right");

			-- Re-enable pausing and time updating, and allow battle speed to be changed
			bm:disable_pausing(false);
			bm:disable_time_speed_controls(false);
			bm:change_conflict_time_update_overridden(false);
		end
	);

end;