load_script_libraries();

bool_benchmark_mode = false;

if bm:is_benchmarking_mode() then
	bool_benchmark_mode = true;
end;

bm:setup_battle(function() end_deployment_phase() end);

alliances = bm:alliances();

alliance_ksl = alliances:item(1);
army_ksl_01 = alliance_ksl:armies():item(1);

alliance_ogr = alliances:item(2); 
army_ogr_01 = alliance_ogr:armies():item(1);

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

-- ogrrne = sunit_ogr --

sunit_ogr_01 = script_unit:new_by_reference(army_ogr_01, "ogr_01");
sunit_ogr_02 = script_unit:new_by_reference(army_ogr_01, "ogr_02");
sunit_ogr_03 = script_unit:new_by_reference(army_ogr_01, "ogr_03");
sunit_ogr_04 = script_unit:new_by_reference(army_ogr_01, "ogr_04");
sunit_ogr_05 = script_unit:new_by_reference(army_ogr_01, "ogr_05");
sunit_ogr_06 = script_unit:new_by_reference(army_ogr_01, "ogr_06");
sunit_ogr_07 = script_unit:new_by_reference(army_ogr_01, "ogr_07");
sunit_ogr_08 = script_unit:new_by_reference(army_ogr_01, "ogr_08");
sunit_ogr_09 = script_unit:new_by_reference(army_ogr_01, "ogr_09");
sunit_ogr_10 = script_unit:new_by_reference(army_ogr_01, "ogr_10");
sunit_ogr_11 = script_unit:new_by_reference(army_ogr_01, "ogr_11");
sunit_ogr_12 = script_unit:new_by_reference(army_ogr_01, "ogr_12");
sunit_ogr_13 = script_unit:new_by_reference(army_ogr_01, "ogr_13");
sunit_ogr_14 = script_unit:new_by_reference(army_ogr_01, "ogr_14");
sunit_ogr_15 = script_unit:new_by_reference(army_ogr_01, "ogr_15");
sunit_ogr_16 = script_unit:new_by_reference(army_ogr_01, "ogr_16");
sunit_ogr_17 = script_unit:new_by_reference(army_ogr_01, "ogr_17");
sunit_ogr_18 = script_unit:new_by_reference(army_ogr_01, "ogr_18");
sunit_ogr_19 = script_unit:new_by_reference(army_ogr_01, "ogr_19");
sunit_ogr_20 = script_unit:new_by_reference(army_ogr_01, "ogr_20");
sunit_ogr_21 = script_unit:new_by_reference(army_ogr_01, "ogr_21");
sunit_ogr_22 = script_unit:new_by_reference(army_ogr_01, "ogr_22");
sunit_ogr_23 = script_unit:new_by_reference(army_ogr_01, "ogr_23");
sunit_ogr_24 = script_unit:new_by_reference(army_ogr_01, "ogr_24");
sunit_ogr_25 = script_unit:new_by_reference(army_ogr_01, "ogr_25");
sunit_ogr_26 = script_unit:new_by_reference(army_ogr_01, "ogr_26");
sunit_ogr_27 = script_unit:new_by_reference(army_ogr_01, "ogr_27");
sunit_ogr_28 = script_unit:new_by_reference(army_ogr_01, "ogr_28");
sunit_ogr_29 = script_unit:new_by_reference(army_ogr_01, "ogr_29");
sunit_ogr_30 = script_unit:new_by_reference(army_ogr_01, "ogr_30");
sunit_ogr_31 = script_unit:new_by_reference(army_ogr_01, "ogr_31");
sunit_ogr_32 = script_unit:new_by_reference(army_ogr_01, "ogr_32");
sunit_ogr_33 = script_unit:new_by_reference(army_ogr_01, "ogr_33");
sunit_ogr_34 = script_unit:new_by_reference(army_ogr_01, "ogr_34");
sunit_ogr_35 = script_unit:new_by_reference(army_ogr_01, "ogr_35");
sunit_ogr_36 = script_unit:new_by_reference(army_ogr_01, "ogr_36");
sunit_ogr_37 = script_unit:new_by_reference(army_ogr_01, "ogr_37");
sunit_ogr_38 = script_unit:new_by_reference(army_ogr_01, "ogr_38");
sunit_ogr_39 = script_unit:new_by_reference(army_ogr_01, "ogr_39");
sunit_ogr_40 = script_unit:new_by_reference(army_ogr_01, "ogr_40");

uc_ogr_01_all = unitcontroller_from_army(army_ogr_01);
uc_ogr_01_all:take_control();

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
	sunit_ogr_01,
	sunit_ogr_01,
	sunit_ogr_02,
	sunit_ogr_03,
	sunit_ogr_04,
	sunit_ogr_05,
	sunit_ogr_06,
	sunit_ogr_07,
	sunit_ogr_08,
	sunit_ogr_09,
	sunit_ogr_10,
	sunit_ogr_11,
	sunit_ogr_12,
	sunit_ogr_13,
	sunit_ogr_14,
	sunit_ogr_15,
	sunit_ogr_16,
	sunit_ogr_17,
	sunit_ogr_18,
	sunit_ogr_19,
	sunit_ogr_20,
	sunit_ogr_21,
	sunit_ogr_22,
	sunit_ogr_23,
	sunit_ogr_24,
	sunit_ogr_25,
	sunit_ogr_26,
	sunit_ogr_27,
	sunit_ogr_28,
	sunit_ogr_29,
	sunit_ogr_30,
	sunit_ogr_31,
	sunit_ogr_32,
	sunit_ogr_33,
	sunit_ogr_34,
	sunit_ogr_35,
	sunit_ogr_36,
	sunit_ogr_37,
	sunit_ogr_38,
	sunit_ogr_39,
	sunit_ogr_40
	
);

sunits_kislev_ranged_01 = script_units:new(
	"ksl_ranged_01",
	sunit_ksl_11,
	sunit_ksl_12,
	sunit_ksl_16,
	sunit_ksl_17
	
);

sunits_kislev_ranged_02 = script_units:new(
	"ksl_ranged_02",
	sunit_ksl_10,
	sunit_ksl_14,
	sunit_ksl_15
	
);

sunits_gnoblar_frontline_01 = script_units:new(
	"gnoblar_fl_01",
	sunit_ogr_21,
	sunit_ogr_22,
	sunit_ogr_23,
	sunit_ogr_24,
	sunit_ogr_25
	
);

sunits_gnoblar_frontline_02 = script_units:new(
	"gnoblar_fl_02",
	sunit_ogr_26,
	sunit_ogr_27,
	sunit_ogr_28,
	sunit_ogr_31
	
);

sunits_gnoblar_frontline_03 = script_units:new(
	"gnoblar_fl_03",
	sunit_ogr_29,
	sunit_ogr_30
	
);

sunits_ogre_frontline_02 = script_units:new(
	"ogre_fl_02",
	sunit_ogr_02,
	sunit_ogr_08,
	sunit_ogr_14

);

sunits_ogre_secondline_01 = script_units:new(
	"ogre_sl_01",
	sunit_ogr_03,
	sunit_ogr_09,
	sunit_ogr_10,
	sunit_ogr_13

);

sunits_ogre_artillery_02 = script_units:new(
	"ogre_art_02",
	sunit_ogr_16,
	sunit_ogr_17,
	sunit_ogr_18,
	sunit_ogr_19,
	sunit_ogr_20,
	sunit_ogr_36,
	sunit_ogr_37

);

function end_deployment_phase()
	bm:out("Starting benchmark");
	
	if bool_benchmark_mode then
		play_cutscene_intro();
	end;
	
	for i = 1, sunits_all:count() do
		local current_sunit = sunits_all:item(i);

		current_sunit.uc:change_behaviour_active("skirmish", false);
		
	end;
	
	bm:callback(
		function()
		
			sunit_ogr_11:goto_location_offset(0, 80, true, 90);
		
		end,
		50
	);
	
	bm:callback(
		function()
		
			sunits_ogre_secondline_01:goto_location_offset(0, 80, true, 90);
		
		end,
		2000
	);
	
		
	bm:callback(
		function()
						
			sunits_kislev_ranged_02:change_behaviour_active("fire_at_will", false);
			sunits_ogre_artillery_02:change_behaviour_active("fire_at_will", false);
			
			sunits_gnoblar_frontline_01:goto_location_offset(0, 50, true, 90);
			
			sunit_ogr_38.uc:attack_unit(sunit_ksl_12.unit, true, true);
			--sunit_ogr_39.uc:attack_unit(sunit_ksl_11.unit, true, true);
			sunit_ogr_40.uc:attack_unit(sunit_ksl_12.unit, true, true);
			
		end,
		7000
	);
	
		bm:callback(
		function()
			
			sunit_ogr_04.uc:attack_unit(sunit_ksl_03.unit, true, true);
			sunit_ogr_05.uc:attack_unit(sunit_ksl_03.unit, true, true);
			
		end,
		20000
	);
	
	bm:callback(
		function()
		
			sunits_kislev_ranged_02:change_behaviour_active("fire_at_will", true);
			sunits_ogre_artillery_02:change_behaviour_active("fire_at_will", true);
		
			sunits_gnoblar_frontline_02:goto_location_offset(0, 40, true, 0);
			sunits_gnoblar_frontline_03:goto_location_offset(0, 40, true, 45);	
			sunits_ogre_frontline_02:goto_location_offset(0, 70, true, 0);
			
			--sunit_ogr_17.uc:attack_unit(sunit_ksl_14.unit, true, true);
			--sunit_ogr_18.uc:attack_unit(sunit_ksl_17.unit, true, true);
			sunit_ogr_20.uc:attack_unit(sunit_ksl_06.unit, true, true);
			
		end,
		26000
	);

	bm:callback(
		function()
			
			sunit_ogr_07.uc:attack_unit(sunit_ksl_04.unit, true, true);
			sunit_ksl_04.uc:attack_unit(sunit_ogr_07.unit, true, true);
			
			sunit_ksl_01.uc:perform_special_ability("wh3_main_spell_ice_ice_sheet", sunit_ogr_04.unit);
			
		end,
		35000
	);
	
	bm:callback(
		function()
		
			sunit_ksl_21.uc:perform_special_ability("wh3_main_spell_tempest_hailstorm", sunit_ogr_35.unit);
			
		end,
		42000
	);
	
	
	bm:callback(
		function()
		
			sunit_ogr_12.uc:attack_unit(sunit_ksl_19.unit, true, true);
			sunit_ksl_19.uc:attack_unit(sunit_ogr_12.unit, true, true);
			
		end,
		50000
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
		
	--- First Scene ---
	cutscene_intro:action(function() cam:move_to(v(-513.90448,240.664459,769.162231),v(-305.810425,170.959778,603.710083), 0, false, -1) end, 0);
	
	--- Pan towards ogre front line 1 ---
	cutscene_intro:action(function() cam:move_to(v(-333.354614,84.685181,588.238647),v(-140.273727,95.825104,392.963867), 8, false, -1) end, 5000);
	
	--- Pan towards opposite end of ogre front line 1 ---
	cutscene_intro:action(function() cam:move_to(v(-319.513855,130.497574,333.207489),v(-149.471161,38.328453,528.469299), 6, false, -1) end, 14000);
	
	--- circle keep scene 1 ---
	cutscene_intro:action(function() cam:move_to(v(-500.956116,171.460846,-31.58835),v(-265.123962,211.91539,103.629593), 5, false, -1) end, 20000);
	
	--- pan towards defending kislev against front line 2 ---
	cutscene_intro:action(function() cam:move_to(v(201.899719,118.495392,33.418461),v(259.272156,-10.577667,-202.346268), 0, false, -1) end, 27000);
	
	--- chokepoint clash 1 ---
	cutscene_intro:action(function() cam:move_to(v(148.949554,143.283539,358.931244),v(361.74585,13.227188,243.434265), 0, false, -1) end, 35000);
	
	--- chokepoint clash 2 ---
	cutscene_intro:action(function() cam:move_to(v(40.985645,163.392685,364.07901),v(61.41568,136.028931,400.995758), 3, false, -1) end, 42000);
	
	--- Chokepoint clash 2 zoomin --
	cutscene_intro:action(function() cam:move_to(v(51.900867,133.085907,437.529236),v(87.936424,121.267616,470.556488), 3, false, -1) end, 46000);
	
	--- monsterous clash ---
	cutscene_intro:action(function() cam:move_to(v(225.056992,156.094467,285.487701),v(183.007263,139.857376,263.189209), 6, false, -1) end, 53000);
	
	cutscene_intro:action(function() cam:fade(true, 0.5) end, 64000);
	cutscene_intro:start();	
end;