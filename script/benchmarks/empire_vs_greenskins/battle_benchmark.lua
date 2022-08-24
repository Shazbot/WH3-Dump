load_script_libraries();

bool_benchmark_mode = false;

if bm:is_benchmarking_mode() then
	bool_benchmark_mode = true;
end;

bm:setup_battle(function() end_deployment_phase() end);

alliances = bm:alliances();

alliance_grn = alliances:item(1);
army_grn_01 = alliance_grn:armies():item(1);

alliance_emp = alliances:item(2); 
army_emp_01 = alliance_emp:armies():item(1);

sunit_grn_01 = script_unit:new_by_reference(army_grn_01, "grn_01");
sunit_grn_02 = script_unit:new_by_reference(army_grn_01, "grn_02");
sunit_grn_03 = script_unit:new_by_reference(army_grn_01, "grn_03");
sunit_grn_04 = script_unit:new_by_reference(army_grn_01, "grn_04");
sunit_grn_05 = script_unit:new_by_reference(army_grn_01, "grn_05");
sunit_grn_06 = script_unit:new_by_reference(army_grn_01, "grn_06");
sunit_grn_07 = script_unit:new_by_reference(army_grn_01, "grn_07");
sunit_grn_08 = script_unit:new_by_reference(army_grn_01, "grn_08");
sunit_grn_09 = script_unit:new_by_reference(army_grn_01, "grn_09");
sunit_grn_10 = script_unit:new_by_reference(army_grn_01, "grn_10");
sunit_grn_11 = script_unit:new_by_reference(army_grn_01, "grn_11");
sunit_grn_12 = script_unit:new_by_reference(army_grn_01, "grn_12");
sunit_grn_13 = script_unit:new_by_reference(army_grn_01, "grn_13");
sunit_grn_14 = script_unit:new_by_reference(army_grn_01, "grn_14");
sunit_grn_15 = script_unit:new_by_reference(army_grn_01, "grn_15");
sunit_grn_16 = script_unit:new_by_reference(army_grn_01, "grn_16");
sunit_grn_17 = script_unit:new_by_reference(army_grn_01, "grn_17");
sunit_grn_18 = script_unit:new_by_reference(army_grn_01, "grn_18");
sunit_grn_19 = script_unit:new_by_reference(army_grn_01, "grn_19");

uc_grn_01_all = unitcontroller_from_army(army_grn_01);
uc_grn_01_all:take_control();

sunits_grn_all = script_units:new(
	"grn_all",
	sunit_grn_01,
	sunit_grn_02,
	sunit_grn_03,
	sunit_grn_04,
	sunit_grn_05,
	sunit_grn_06,
	sunit_grn_07,
	sunit_grn_08,
	sunit_grn_09,
	sunit_grn_10,
	sunit_grn_11,
	sunit_grn_12,
	sunit_grn_13,
	sunit_grn_14,
	sunit_grn_15,
	sunit_grn_16,
	sunit_grn_17,
	sunit_grn_18,
	sunit_grn_19
);

sunits_grn_melee = script_units:new(
	"grn_melee",
	sunit_grn_03,
	sunit_grn_04,
	sunit_grn_05,
	sunit_grn_06,
	sunit_grn_07,
	sunit_grn_08,
	sunit_grn_09,
	sunit_grn_10,
	sunit_grn_14,
	sunit_grn_15,
	sunit_grn_16,
	sunit_grn_17
);

sunit_emp_01 = script_unit:new_by_reference(army_emp_01, "emp_01");
sunit_emp_02 = script_unit:new_by_reference(army_emp_01, "emp_02");
sunit_emp_03 = script_unit:new_by_reference(army_emp_01, "emp_03");
sunit_emp_04 = script_unit:new_by_reference(army_emp_01, "emp_04");
sunit_emp_05 = script_unit:new_by_reference(army_emp_01, "emp_05");
sunit_emp_06 = script_unit:new_by_reference(army_emp_01, "emp_06");
sunit_emp_07 = script_unit:new_by_reference(army_emp_01, "emp_07");
sunit_emp_08 = script_unit:new_by_reference(army_emp_01, "emp_08");
sunit_emp_09 = script_unit:new_by_reference(army_emp_01, "emp_09");
sunit_emp_10 = script_unit:new_by_reference(army_emp_01, "emp_10");
sunit_emp_11 = script_unit:new_by_reference(army_emp_01, "emp_11");
sunit_emp_12 = script_unit:new_by_reference(army_emp_01, "emp_12");
sunit_emp_13 = script_unit:new_by_reference(army_emp_01, "emp_13");
sunit_emp_14 = script_unit:new_by_reference(army_emp_01, "emp_14");
sunit_emp_15 = script_unit:new_by_reference(army_emp_01, "emp_15");
sunit_emp_16 = script_unit:new_by_reference(army_emp_01, "emp_16");

uc_emp_01_all = unitcontroller_from_army(army_emp_01);
uc_emp_01_all:take_control();

sunits_emp_cav = script_units:new(
	"emp_cav",
	sunit_emp_10,
	sunit_emp_11,
	sunit_emp_12,
	sunit_emp_13,
	sunit_emp_14
);

function end_deployment_phase()
	bm:out("Starting benchmark");
	
	if bool_benchmark_mode then
		play_cutscene_intro();
	end;
	
	sunit_grn_01.uc:set_invincible(true);
	sunit_grn_02.uc:set_invincible(true);
	sunit_emp_01.uc:set_invincible(true);
	sunit_emp_02.uc:set_invincible(true);
	sunits_grn_melee:goto_location_offset(0, 50, false, 0);
	sunit_grn_11.uc:attack_unit(sunit_emp_08.unit);
	sunit_grn_12.uc:attack_unit(sunit_emp_14.unit);
	sunit_grn_13.uc:attack_unit(sunit_emp_14.unit);
	
	bm:callback(
		function()
			sunit_grn_05.uc:attack_unit(sunit_emp_04.unit, true, true);
			sunit_grn_03.uc:attack_unit(sunit_emp_04.unit, true, true);
			sunit_grn_07.uc:attack_unit(sunit_emp_04.unit, true, true);
			sunit_grn_08.uc:attack_unit(sunit_emp_06.unit, true, true);
			sunit_grn_09.uc:attack_unit(sunit_emp_15.unit, true, true);
			sunit_grn_10.uc:attack_unit(sunit_emp_03.unit, true, true);
			sunit_grn_17.uc:attack_unit(sunit_emp_03.unit, true, true);
			sunit_grn_06.uc:attack_unit(sunit_emp_03.unit, true, true);
			sunits_emp_cav:goto_location_offset(0, 50, true, 0);
		end,
		10000
	);
	
	bm:callback(
		function()
			sunit_emp_01.uc:attack_unit(sunit_grn_01.unit, true, true);
			sunit_grn_01.uc:attack_unit(sunit_emp_01.unit, true, true);
		end,
		28000
	);
end;

cutscene_intro = cutscene:new(
	"cutscene_intro", 							-- unique string name for cutscene
	uc_grn_01_all, 								-- unitcontroller over player's army
	38000, 										-- duration of cutscene in ms
	function() bm:end_benchmark() end 			-- what to call when cutscene is finished
);

cam = cutscene_intro:camera();
cutscene_intro:set_skippable(false, nil);
--cutscene_intro:set_debug();

function play_cutscene_intro()
	cutscene_intro:action(function() cam:fade(false, 0.5) end, 0);
	
	cutscene_intro:action(function() cam:move_to(v(-237.187897,453.442627,-30.374233),v(-247.457291,437.073425,12.448322), 0, true, -1) end, 0);
	cutscene_intro:action(function() cam:move_to(v(-262.790375,453.442627,-26.695709),v(-268.294983,436.394562,16.73521), 10, true, -1) end, 0);
	
	cutscene_intro:action(function() cam:move_to(v(-168.945328,454.224915,80.563744),v(-213.925018,451.618317,66.929108), 0, true, -1) end, 4000);
	cutscene_intro:action(function() cam:move_to(v(-170.267654,453.342224,87.304405),v(-208.811722,452.866425,60.285877), 8, true, -1) end, 4000);
	
	cutscene_intro:action(function() cam:move_to(v(-268.957428,435.925903,-21.464111),v(-273.678528,429.136261,24.876663), 0, true, -1) end, 7000);
	
	cutscene_intro:action(function() cam:move_to(v(-304.743835,457.342224,63.792618),v(-297.756958,439.988403,109.75972), 0, true, -1) end, 11000);
	cutscene_intro:action(function() cam:move_to(v(-304.083221,457.342224,86.323837),v(-297.096344,439.988403,132.290939), 8, true, -1) end, 11000);
	
	cutscene_intro:action(function() cam:move_to(v(-194.072495,451.342224,163.617218),v(-228.084793,444.583099,131.783813), 0, true, -1) end, 19000);
	cutscene_intro:action(function() cam:move_to(v(-194.072495,451.342224,163.617218),v(-239.755829,442.05307,157.087921), 10, true, -1) end, 19000);
	
	cutscene_intro:action(function() cam:move_to(v(-239.415329,478.842224,98.430389),v(-262.735016,459.424255,134.416901), 0, true, -1) end, 28000);
	cutscene_intro:action(function() cam:move_to(v(-265.516296,489.342224,87.882286),v(-272.013184,473.090576,126.411942), 10, true, -1) end, 28000);
	
	cutscene_intro:action(function() cam:move_to(v(-249.45491,476.232391,103.560234),v(-291.178589,475.10022,125.326172), 0, true, -1) end, 31000);
	cutscene_intro:action(function() cam:move_to(v(-258.368134,476.232391,93.824471),v(-288.973389,473.484375,129.48497), 10, true, -1) end, 31000);
		
	cutscene_intro:action(function() cam:fade(true, 0.5) end, 37000);
	
	cutscene_intro:start();	
end;