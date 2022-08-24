load_script_libraries();

bool_benchmark_mode = false;

if bm:is_benchmarking_mode() then
	bool_benchmark_mode = true;
end;

bm:setup_battle(function() end_deployment_phase() end);

alliances = bm:alliances();

alliance_lzd = alliances:item(1);
army_lzd_01 = alliance_lzd:armies():item(1);

alliance_hef = alliances:item(2); 
army_hef_01 = alliance_hef:armies():item(1);

sunit_lzd_01 = script_unit:new_by_reference(army_lzd_01, "lzd_01");
sunit_lzd_02 = script_unit:new_by_reference(army_lzd_01, "lzd_02");
sunit_lzd_03 = script_unit:new_by_reference(army_lzd_01, "lzd_03");
sunit_lzd_04 = script_unit:new_by_reference(army_lzd_01, "lzd_04");
sunit_lzd_05 = script_unit:new_by_reference(army_lzd_01, "lzd_05");
sunit_lzd_06 = script_unit:new_by_reference(army_lzd_01, "lzd_06");
sunit_lzd_07 = script_unit:new_by_reference(army_lzd_01, "lzd_07");
sunit_lzd_08 = script_unit:new_by_reference(army_lzd_01, "lzd_08");
sunit_lzd_09 = script_unit:new_by_reference(army_lzd_01, "lzd_09");
sunit_lzd_10 = script_unit:new_by_reference(army_lzd_01, "lzd_10");
sunit_lzd_11 = script_unit:new_by_reference(army_lzd_01, "lzd_11");
sunit_lzd_12 = script_unit:new_by_reference(army_lzd_01, "lzd_12");
sunit_lzd_13 = script_unit:new_by_reference(army_lzd_01, "lzd_13");
sunit_lzd_14 = script_unit:new_by_reference(army_lzd_01, "lzd_14");
sunit_lzd_15 = script_unit:new_by_reference(army_lzd_01, "lzd_15");
sunit_lzd_16 = script_unit:new_by_reference(army_lzd_01, "lzd_16");
sunit_lzd_17 = script_unit:new_by_reference(army_lzd_01, "lzd_17");
sunit_lzd_18 = script_unit:new_by_reference(army_lzd_01, "lzd_18");
sunit_lzd_19 = script_unit:new_by_reference(army_lzd_01, "lzd_19");
sunit_lzd_20 = script_unit:new_by_reference(army_lzd_01, "lzd_20");

uc_lzd_01_all = unitcontroller_from_army(army_lzd_01);
uc_lzd_01_all:take_control();

sunits_lzd_movement = script_units:new(
	"lzd_movement",
	sunit_lzd_01,
	sunit_lzd_02,
	sunit_lzd_03,
	sunit_lzd_04,
	sunit_lzd_05,
	sunit_lzd_06,
	sunit_lzd_07,
	sunit_lzd_08,
	sunit_lzd_09,
	sunit_lzd_14,
	sunit_lzd_15,
	sunit_lzd_16,
	sunit_lzd_17,
	sunit_lzd_18,
	sunit_lzd_19,
	sunit_lzd_20
);

sunit_hef_01 = script_unit:new_by_reference(army_hef_01, "hef_01");
sunit_hef_02 = script_unit:new_by_reference(army_hef_01, "hef_02");
sunit_hef_03 = script_unit:new_by_reference(army_hef_01, "hef_03");
sunit_hef_04 = script_unit:new_by_reference(army_hef_01, "hef_04");
sunit_hef_05 = script_unit:new_by_reference(army_hef_01, "hef_05");
sunit_hef_06 = script_unit:new_by_reference(army_hef_01, "hef_06");
sunit_hef_07 = script_unit:new_by_reference(army_hef_01, "hef_07");
sunit_hef_08 = script_unit:new_by_reference(army_hef_01, "hef_08");
sunit_hef_09 = script_unit:new_by_reference(army_hef_01, "hef_09");
sunit_hef_10 = script_unit:new_by_reference(army_hef_01, "hef_10");
sunit_hef_11 = script_unit:new_by_reference(army_hef_01, "hef_11");
sunit_hef_12 = script_unit:new_by_reference(army_hef_01, "hef_12");
sunit_hef_13 = script_unit:new_by_reference(army_hef_01, "hef_13");
sunit_hef_14 = script_unit:new_by_reference(army_hef_01, "hef_14");
sunit_hef_15 = script_unit:new_by_reference(army_hef_01, "hef_15");
sunit_hef_16 = script_unit:new_by_reference(army_hef_01, "hef_16");
--sunit_hef_17 = script_unit:new_by_reference(army_hef_01, "hef_17");
sunit_hef_18 = script_unit:new_by_reference(army_hef_01, "hef_18");
sunit_hef_19 = script_unit:new_by_reference(army_hef_01, "hef_19");

uc_hef_01_all = unitcontroller_from_army(army_hef_01);
uc_hef_01_all:take_control();

sunits_hef_movement = script_units:new(
	"hef_movement",
	sunit_hef_01,
	sunit_hef_02,
	sunit_hef_03,
	sunit_hef_04,
	sunit_hef_05,
	sunit_hef_06,
	sunit_hef_07,
	sunit_hef_08,
	sunit_hef_09,
	sunit_hef_10,
	sunit_hef_13,
	sunit_hef_14,
	sunit_hef_15,
	sunit_hef_16
	--sunit_hef_17
);

sunits_all = script_units:new(
	"all",
	sunit_lzd_01,
	sunit_lzd_02,
	sunit_lzd_03,
	sunit_lzd_04,
	sunit_lzd_05,
	sunit_lzd_06,
	sunit_lzd_07,
	sunit_lzd_08,
	sunit_lzd_09,
	sunit_lzd_10,
	sunit_lzd_11,
	sunit_lzd_12,
	sunit_lzd_13,
	sunit_lzd_14,
	sunit_lzd_15,
	sunit_lzd_16,
	sunit_lzd_17,
	sunit_lzd_18,
	sunit_lzd_19,
	sunit_lzd_20,
	sunit_hef_01,
	sunit_hef_02,
	sunit_hef_03,
	sunit_hef_04,
	sunit_hef_05,
	sunit_hef_06,
	sunit_hef_07,
	sunit_hef_08,
	sunit_hef_09,
	sunit_hef_10,
	sunit_hef_11,
	sunit_hef_12,
	sunit_hef_13,
	sunit_hef_14,
	sunit_hef_15,
	sunit_hef_16,
	--sunit_hef_17,
	sunit_hef_18,
	sunit_hef_19
);

function end_deployment_phase()
	bm:out("Starting benchmark");
	
	if bool_benchmark_mode then
		play_cutscene_intro();
	end;
	
	-- teleport the guerrilla deployment lizardmen units, they don't seem to deploy properly
	sunit_lzd_10.uc:teleport_to_location(v(-152.35, -638.76), 0.14, 44.4);
	sunit_lzd_11.uc:teleport_to_location(v(-106.44, -645.46), 0.14, 44.4);
	sunit_lzd_12.uc:teleport_to_location(v(109.87, -643.95), 6.15, 44.4);
	sunit_lzd_13.uc:teleport_to_location(v(155.84, -637.65), 6.15, 44.4);
	
	for i = 1, sunits_all:count() do
		local current_sunit = sunits_all:item(i);
		
		current_sunit.uc:change_behaviour_active("fire_at_will", false);
		current_sunit.uc:change_behaviour_active("skirmish", false);
	end;
	
	sunits_lzd_movement:goto_location_offset(0, 60, false, 0);
	sunits_hef_movement:goto_location_offset(0, 32, false, 180);
	
	-- first line
	bm:callback(
		function()
			sunit_lzd_02.uc:attack_unit(sunit_hef_04.unit, true, true);
			sunit_lzd_06.uc:attack_unit(sunit_hef_03.unit, true, true);
			sunit_lzd_07.uc:attack_unit(sunit_hef_02.unit, true, true);
		end,
		20000
	);
	
	-- second line
	bm:callback(
		function()
			sunit_lzd_03.uc:attack_unit(sunit_hef_04.unit, true, true);
			sunit_lzd_04.uc:attack_unit(sunit_hef_03.unit, true, true);
			sunit_lzd_05.uc:attack_unit(sunit_hef_02.unit, true, true);
		end,
		25000
	);
	
	-- archers
	bm:callback(
		function()
			sunit_hef_13.uc:attack_unit(sunit_lzd_03.unit, true, true);
			sunit_hef_10.uc:attack_unit(sunit_lzd_03.unit, true, true);
			
			sunit_hef_09.uc:attack_unit(sunit_lzd_05.unit, true, true);
			sunit_hef_08.uc:attack_unit(sunit_lzd_05.unit, true, true);
		end,
		29500
	);
	
	bm:callback(
		function()
			sunit_hef_13.uc:halt();
			sunit_hef_10.uc:halt();
			sunit_hef_09.uc:halt();
			sunit_hef_08.uc:halt();
		end,
		32500
	);
	
	--[[ dragon
	bm:callback(
		function()
			sunit_hef_17.uc:teleport_to_location(v(-184, -556), 0, 10);
			sunit_hef_17.uc:perform_special_ability("wh2_main_unit_abilities_hef_sundragon_breath", sunit_lzd_02.unit);
		end,
		40000
	);]]
end;

cutscene_intro = cutscene:new(
	"cutscene_intro", 							-- unique string name for cutscene
	uc_lzd_01_all, 								-- unitcontroller over player's army
	46000, 										-- duration of cutscene in ms
	function() bm:end_benchmark() end 			-- what to call when cutscene is finished
);

cam = cutscene_intro:camera();
cutscene_intro:set_skippable(false, nil);
--cutscene_intro:set_debug();

function play_cutscene_intro()
	cutscene_intro:action(function() cam:fade(false, 0.5) end, 0);
	
	cutscene_intro:action(function() cam:move_to(v(59.270142,96.302826,-820.231262),v(-11.443741,-43.134155,-647.226196), 0, true, -1) end, 0);
	cutscene_intro:action(function() cam:move_to(v(0.141946,92.85955,-769.952515),v(1.932629,-78.440697,-611.75354), 14, true, -1) end, 0);
	
	cutscene_intro:action(function() cam:move_to(v(14.082555,14.998534,-689.41156),v(-195.467865,-44.763538,-772.424194), 0, true, -1) end, 5000);
	cutscene_intro:action(function() cam:move_to(v(14.226415,15.3863,-678.480103),v(-195.324112,-44.37579,-761.492615), 6, true, -1) end, 5000);
	
	cutscene_intro:action(function() cam:move_to(v(38.034737,25.286659,-526.692688),v(20.069935,0.602983,-490.861938), 0, true, -1) end, 8500);
	cutscene_intro:action(function() cam:move_to(v(11.528695,28.286659,-531.943604),v(7.513195,1.991253,-493.106689), 14, true, -1) end, 8500);
	
	cutscene_intro:action(function() cam:move_to(v(0.966572,13.008644,-513.09259),v(0.530934,-0.81366,-465.43042), 0, true, -1) end, 15000);
	cutscene_intro:action(function() cam:move_to(v(0.975712,13.008644,-514.092529),v(0.540074,-0.813658,-466.430389), 4, true, -1) end, 15000);
	
	cutscene_intro:action(function() cam:move_to(v(52.992184,20.679558,-623.158813),v(35.494553,1.721586,-583.784607), 0, true, -1) end, 18000);
	cutscene_intro:action(function() cam:move_to(v(56.772892,16.07946,-582.919128),v(38.602921,2.258744,-547.286438), 20, true, -1) end, 18000);
	
	cutscene_intro:action(function() cam:move_to(v(2.521387,40.07946,-617.07135),v(2.526572,13.110985,-584.459473), 0, true, -1) end, 25000);
	cutscene_intro:action(function() cam:move_to(v(2.524568,37.07946,-597.07135),v(3.183055,13.078949,-562.223572), 8, true, -1) end, 25000);
	
	cutscene_intro:action(function() cam:move_to(v(44.180599,13.07946,-487.777344),v(15.25771,-1.071551,-460.317413), 0, true, -1) end, 30000);
	
	cutscene_intro:action(function() cam:move_to(v(50.62455,16.07946,-551.316895),v(16.141285,-0.414186,-533.158264), 0, true, -1) end, 33000);
	cutscene_intro:action(function() cam:move_to(v(50.024616,14.57946,-532.923706),v(11.252464,0.650654,-523.250122), 9, true, -1) end, 33000);
	
	cutscene_intro:action(function() cam:move_to(v(43.038456,31.07946,-558.519226),v(15.443464,4.078054,-541.189331), 0, true, -1) end, 40000);
	cutscene_intro:action(function() cam:move_to(v(19.935993,35.57946,-561.017578),v(5.479791,5.526306,-534.965393), 10, true, -1) end, 40000);
	
	--[[cutscene_intro:action(function() cam:move_to(v(-114.750954,23.57946,-547.019409),v(-153.869141,9.453964,-554.838745), 0, true, -1) end, 45000);
	cutscene_intro:action(function() cam:move_to(v(-61.305595,32.57946,-544.079651),v(-99.200195,14.564102,-549.587585), 6, true, -1) end, 45000);
	
	cutscene_intro:action(function() cam:move_to(v(-38.111145,32.57946,-572.142212),v(-52.669907,12.002047,-538.149658), 0, true, -1) end, 50000);
	cutscene_intro:action(function() cam:move_to(v(-35.394684,32.57946,-570.869385),v(-52.550659,11.685282,-538.312012), 10, true, -1) end, 50000);	]]
		
	cutscene_intro:action(function() cam:fade(true, 0.5) end, 45000);
	
	cutscene_intro:start();	
end;