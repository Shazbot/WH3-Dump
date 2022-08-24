load_script_libraries();

bool_benchmark_mode = false;

if bm:is_benchmarking_mode() then
	bool_benchmark_mode = true;
end;

bm:setup_battle(function() end_deployment_phase() end);

alliances = bm:alliances();

alliance_ksl = alliances:item(1);
army_ksl_01 = alliance_ksl:armies():item(1);

alliance_kho = alliances:item(2); 
army_kho_01 = alliance_kho:armies():item(1);

-- Kislev = sunit_ksl --

sunit_ksl_01 = script_unit:new_by_reference(army_ksl_01, "ksl_01");
sunit_ksl_02 = script_unit:new_by_reference(army_ksl_01, "ksl_02");
sunit_ksl_03 = script_unit:new_by_reference(army_ksl_01, "ksl_03");
sunit_ksl_04 = script_unit:new_by_reference(army_ksl_01, "ksl_04");
sunit_ksl_05 = script_unit:new_by_reference(army_ksl_01, "ksl_05");
sunit_ksl_06 = script_unit:new_by_reference(army_ksl_01, "ksl_06");
sunit_ksl_07 = script_unit:new_by_reference(army_ksl_01, "ksl_07");
sunit_ksl_08 = script_unit:new_by_reference(army_ksl_01, "ksl_08");
sunit_ksl_09 = script_unit:new_by_reference(army_ksl_01, "ksl_09");
sunit_ksl_10 = script_unit:new_by_reference(army_ksl_01, "ksl_10");
sunit_ksl_11 = script_unit:new_by_reference(army_ksl_01, "ksl_11");
sunit_ksl_12 = script_unit:new_by_reference(army_ksl_01, "ksl_12");
sunit_ksl_13 = script_unit:new_by_reference(army_ksl_01, "ksl_13");
sunit_ksl_14 = script_unit:new_by_reference(army_ksl_01, "ksl_14");
sunit_ksl_15 = script_unit:new_by_reference(army_ksl_01, "ksl_15");
sunit_ksl_16 = script_unit:new_by_reference(army_ksl_01, "ksl_16");
sunit_ksl_17 = script_unit:new_by_reference(army_ksl_01, "ksl_17");
sunit_ksl_18 = script_unit:new_by_reference(army_ksl_01, "ksl_18");
sunit_ksl_19 = script_unit:new_by_reference(army_ksl_01, "ksl_19");
sunit_ksl_20 = script_unit:new_by_reference(army_ksl_01, "ksl_20");
sunit_ksl_21 = script_unit:new_by_reference(army_ksl_01, "ksl_21");

uc_ksl_01_all = unitcontroller_from_army(army_ksl_01);
uc_ksl_01_all:take_control();

-- Khorne = sunit_kho --

sunit_kho_01 = script_unit:new_by_reference(army_kho_01, "kho_01");
sunit_kho_02 = script_unit:new_by_reference(army_kho_01, "kho_02");
sunit_kho_03 = script_unit:new_by_reference(army_kho_01, "kho_03");
sunit_kho_04 = script_unit:new_by_reference(army_kho_01, "kho_04");
sunit_kho_05 = script_unit:new_by_reference(army_kho_01, "kho_05");
sunit_kho_06 = script_unit:new_by_reference(army_kho_01, "kho_06");
sunit_kho_07 = script_unit:new_by_reference(army_kho_01, "kho_07");
sunit_kho_08 = script_unit:new_by_reference(army_kho_01, "kho_08");
sunit_kho_09 = script_unit:new_by_reference(army_kho_01, "kho_09");
sunit_kho_10 = script_unit:new_by_reference(army_kho_01, "kho_10");
sunit_kho_11 = script_unit:new_by_reference(army_kho_01, "kho_11");
sunit_kho_12 = script_unit:new_by_reference(army_kho_01, "kho_12");
sunit_kho_13 = script_unit:new_by_reference(army_kho_01, "kho_13");
sunit_kho_14 = script_unit:new_by_reference(army_kho_01, "kho_14");
sunit_kho_15 = script_unit:new_by_reference(army_kho_01, "kho_15");
sunit_kho_16 = script_unit:new_by_reference(army_kho_01, "kho_16");
sunit_kho_17 = script_unit:new_by_reference(army_kho_01, "kho_17");
sunit_kho_18 = script_unit:new_by_reference(army_kho_01, "kho_18");
sunit_kho_19 = script_unit:new_by_reference(army_kho_01, "kho_19");
sunit_kho_20 = script_unit:new_by_reference(army_kho_01, "kho_20");
sunit_kho_21 = script_unit:new_by_reference(army_kho_01, "kho_21");

uc_kho_01_all = unitcontroller_from_army(army_kho_01);
uc_kho_01_all:take_control();

sunits_all = script_units:new(
	"all",
	sunit_ksl_01,
	sunit_ksl_02,
	sunit_ksl_03,
	sunit_ksl_04,
	sunit_ksl_05,
	sunit_ksl_06,
	sunit_ksl_07,
	sunit_ksl_08,
	sunit_ksl_09,
	sunit_ksl_10,
	sunit_ksl_11,
	sunit_ksl_12,
	sunit_ksl_13,
	sunit_ksl_14,
	sunit_ksl_15,
	sunit_ksl_16,
	sunit_ksl_17,
	sunit_ksl_18,
	sunit_ksl_19,
	sunit_ksl_20,
	sunit_ksl_21,
	sunit_kho_01,
	sunit_kho_01,
	sunit_kho_02,
	sunit_kho_03,
	sunit_kho_04,
	sunit_kho_05,
	sunit_kho_06,
	sunit_kho_07,
	sunit_kho_08,
	sunit_kho_09,
	sunit_kho_10,
	sunit_kho_11,
	sunit_kho_12,
	sunit_kho_13,
	sunit_kho_14,
	sunit_kho_15,
	sunit_kho_16,
	sunit_kho_17,
	sunit_kho_18,
	sunit_kho_19,
	sunit_kho_20,
	sunit_kho_21
	
);

sunits_kislev_movement = script_units:new(
	"ksl_movement",
	sunit_ksl_02,
	sunit_ksl_03,
	sunit_ksl_04,
	sunit_ksl_05, 
	sunit_ksl_06,
	sunit_ksl_07,
	sunit_ksl_08, 
	sunit_ksl_09, 
	sunit_ksl_10,
	sunit_ksl_11,
	sunit_ksl_12, 
	sunit_ksl_14,
	sunit_ksl_19,
	sunit_ksl_20

);

sunits_korne_movement = script_units:new(
	"kho_movement",
	sunit_kho_02,
	sunit_kho_03,
	sunit_kho_04,
	sunit_kho_05,
	sunit_kho_06,
	sunit_kho_07,
	sunit_kho_08,
	sunit_kho_09,
	sunit_kho_10,
	sunit_kho_11,
	sunit_kho_12,
	sunit_kho_13,
	sunit_kho_14,
	sunit_kho_15,
	sunit_kho_16,
	sunit_kho_20,
	sunit_kho_21
	
);

function end_deployment_phase()
	bm:out("Starting benchmark");
	
	if bool_benchmark_mode then
		play_cutscene_intro();
	end;
	
	for i = 1, sunits_all:count() do
		local current_sunit = sunits_all:item(i);
		
		current_sunit.uc:change_behaviour_active("fire_at_will", false);
		current_sunit.uc:change_behaviour_active("skirmish", false);
	end;
		
	bm:callback(
		function()
		
			--- Moving Khorne towards Kislev ---
			sunits_korne_movement:goto_location_offset(0, 300, true, -90);
			
			--- Artillery Attack Orders ---
			sunit_ksl_16.uc:attack_unit(sunit_kho_17.unit, true, true);
			sunit_ksl_17.uc:attack_unit(sunit_kho_04.unit, true, true);
			sunit_ksl_18.uc:attack_unit(sunit_kho_06.unit, true, true);
			---
			sunit_kho_18.uc:attack_unit(sunit_ksl_08.unit, true, true);
			sunit_kho_19.uc:attack_unit(sunit_ksl_09.unit, true, true);
			

		end,
		0
	);
	
	bm:callback(
		function()
		
			--- Delayed Lord Movement - Marching ---
			sunit_kho_01.uc:attack_unit(sunit_ksl_15.unit, false, false);
			
			--- Delayed Flying Movement - Charging ---
			sunit_kho_17.uc:attack_unit(sunit_ksl_04.unit, true, true);
			
		end,
		2000
	);
	
	bm:callback(
		function()
				
			--- Kislev missle troops activate fire at will ---
			sunit_ksl_08.uc:change_behaviour_active("fire_at_will", true);
			sunit_ksl_09.uc:change_behaviour_active("fire_at_will", true);
			sunit_ksl_10.uc:change_behaviour_active("fire_at_will", true);
			sunit_ksl_19.uc:change_behaviour_active("fire_at_will", true);
			sunit_ksl_20.uc:change_behaviour_active("fire_at_will", true);
			
			--- Kislev snow leopard charging 
			sunit_ksl_13.uc:attack_unit(sunit_kho_03.unit, true, true);
			
		end,
		15000
	);
	
	bm:callback(
		function()
			
			--- Kislev Charging forward ---	
			sunits_kislev_movement:goto_location_offset(0, 30, true, 90);
		
		end,
		20000
	);
	
	bm:callback(
		function()
			
			--- Delayed Lord Movement - Charging ---
			sunit_kho_01.uc:attack_unit(sunit_ksl_15.unit, true, true);
			
			--- Elemental bear charging demon prince ---
			sunit_ksl_15.uc:attack_unit(sunit_kho_01.unit, true, true);
			
		end,
		26000
	);
	
	
	bm:callback(
		function()
		
			--- Kislev Lord casting spell --
			sunit_ksl_01.uc:perform_special_ability("wh3_main_spell_tempest_hailstorm_upgraded", sunit_kho_01.unit);
			
		end,
		31000
	);
	
	
	bm:callback(
		function()
		
			--- Elemental bear charging flying demon ---
			sunit_ksl_15.uc:attack_unit(sunit_kho_06.unit, true, true);
		
			--- Khorne Lord casting spell ---
			--sunit_kho_01.uc:perform_special_ability("wh3_main_lord_abilities_bellow_of_endless_fury", sunit_ksl_15.unit);
			
		end,
		34000
	);
	
	
	bm:callback(
		function()

			--- Khorne Cultist casting spell ---
			sunit_kho_21.uc:perform_special_ability("wh3_main_character_abilities_gate_of_khorne", sunit_ksl_18.unit);
			
			--- Kislev Maiden casting spell ---
			sunit_ksl_21.uc:perform_special_ability("wh3_main_spell_ice_ice_sheet", sunit_kho_09.unit);

		end,
		47000
	);
	
end;

--------------------------------------------------------------
------------------------- cutscene ---------------------------
--------------------------------------------------------------

cutscene_intro = cutscene:new(
	"cutscene_intro", 							-- unique string name for cutscene
	uc_ksl_01_all, 								-- unitcontroller over player's army
	64000, 										-- duration of cutscene in ms
	function() bm:end_benchmark() end 			-- what to call when cutscene is finished
);

cam = cutscene_intro:camera();
cutscene_intro:set_skippable(false, nil);
--cutscene_intro:set_debug();

function play_cutscene_intro()
	cutscene_intro:action(function() cam:fade(false, 0.5) end, 0);
	
	--  /                                                                         
	cutscene_intro:action(function() cam:move_to(v(0.548852,559.175293,-252.818695),v(26.228962,504.465973,-162.310699), 0, true, -1) end, 0);
	cutscene_intro:action(function() cam:move_to(v(56.32951,451.093567,-74.342766),v(98.775223,430.895355,23.813774), 8, true, -1) end, 0);
	
	--  /                                                                        
	cutscene_intro:action(function() cam:move_to(v(-70.022125,423.640289,225.308167),v(-19.18082,429.791962,129.27887), 6, true, -1) end, 16000);
	cutscene_intro:action(function() cam:move_to(v(-66.867798,459.723694,0.447686),v(-8.462032,419.01181,-81.867149), 6, true, -1) end, 26000);

	--   /                                               									
	cutscene_intro:action(function() cam:move_to(v(1.070645,475.596954,-94.189293),v(-21.652542,426.000641,-0.016533), 5, true, -1) end, 35000);
	cutscene_intro:action(function() cam:move_to(v(-11.238888,427.947632,235.087662),v(-80.048523,427.335876,150.769943), 6, true, -1) end, 48000);
	
	cutscene_intro:action(function() cam:fade(true, 0.5) end, 64000);
	
	cutscene_intro:start();	
end;