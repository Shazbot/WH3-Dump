load_script_libraries();

bool_benchmark_mode = false;

if bm:is_benchmarking_mode() then
	bool_benchmark_mode = true;
end;

bm:setup_battle(function() end_deployment_phase() end);

alliances = bm:alliances();

alliance_tze = alliances:item(1);
army_tze_01 = alliance_tze:armies():item(1);

alliance_grn = alliances:item(2); 
army_grn_01 = alliance_grn:armies():item(1);

-- Kislev = sunit_tze --

sunit_tze_01 = script_unit:new_by_reference(army_tze_01, "tze_01");
sunit_tze_02 = script_unit:new_by_reference(army_tze_01, "tze_02");
sunit_tze_03 = script_unit:new_by_reference(army_tze_01, "tze_03");
sunit_tze_04 = script_unit:new_by_reference(army_tze_01, "tze_04");
sunit_tze_05 = script_unit:new_by_reference(army_tze_01, "tze_05");
sunit_tze_06 = script_unit:new_by_reference(army_tze_01, "tze_06");
sunit_tze_07 = script_unit:new_by_reference(army_tze_01, "tze_07");
sunit_tze_08 = script_unit:new_by_reference(army_tze_01, "tze_08");
sunit_tze_09 = script_unit:new_by_reference(army_tze_01, "tze_09");
sunit_tze_10 = script_unit:new_by_reference(army_tze_01, "tze_10");
sunit_tze_11 = script_unit:new_by_reference(army_tze_01, "tze_11");
sunit_tze_12 = script_unit:new_by_reference(army_tze_01, "tze_12");
sunit_tze_13 = script_unit:new_by_reference(army_tze_01, "tze_13");
sunit_tze_14 = script_unit:new_by_reference(army_tze_01, "tze_14");
sunit_tze_15 = script_unit:new_by_reference(army_tze_01, "tze_15");

uc_tze_01_all = unitcontroller_from_army(army_tze_01);
uc_tze_01_all:take_control();

-- Greenskins = sunit_grn --

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
sunit_grn_20 = script_unit:new_by_reference(army_grn_01, "grn_20");
sunit_grn_21 = script_unit:new_by_reference(army_grn_01, "grn_21");
-- sunit_grn_22 = script_unit:new_by_reference(army_grn_01, "grn_22");
-- sunit_grn_23 = script_unit:new_by_reference(army_grn_01, "grn_23");
-- sunit_grn_24 = script_unit:new_by_reference(army_grn_01, "grn_24");
-- sunit_grn_25 = script_unit:new_by_reference(army_grn_01, "grn_25");

uc_grn_01_all = unitcontroller_from_army(army_grn_01);
uc_grn_01_all:take_control();

sunits_all = script_units:new(
	"all",
	sunit_tze_01,
	sunit_tze_02,
	sunit_tze_03,
	sunit_tze_04,
	sunit_tze_05,
	sunit_tze_06,
	sunit_tze_07,
	sunit_tze_08,
	sunit_tze_09,
	sunit_tze_10,
	sunit_tze_11,
	sunit_tze_12,
	sunit_tze_13,
	sunit_tze_14,
	sunit_tze_15,
	sunit_grn_01,
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
	sunit_grn_19,
	sunit_grn_20,
	sunit_grn_21
	
);

sunits_tze_all = script_units:new(
	"tze_all",
	sunit_tze_01,
	sunit_tze_02,
	sunit_tze_03,
	sunit_tze_04,
	sunit_tze_05,
	sunit_tze_06,
	sunit_tze_07,
	sunit_tze_08,
	sunit_tze_09,
	sunit_tze_10,
	sunit_tze_11,
	sunit_tze_12,
	sunit_tze_13,
	sunit_tze_14,
	sunit_tze_15

);

sunits_tze_movement = script_units:new(
	"tze_movement",
	sunit_tze_03,
	sunit_tze_04,
	sunit_tze_05,
	sunit_tze_06,
	sunit_tze_07,
	sunit_tze_08,
	sunit_tze_09

);

sunits_grn_movement_1 = script_units:new(
	"grn_movement_1",
	sunit_grn_01,
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
	sunit_grn_19,
	sunit_grn_20,
	sunit_grn_21
	
);

-- sunits_grn_movement_2 = script_units:new(
-- 	"grn_movement_2",
-- 	sunit_grn_22,
-- 	sunit_grn_23,
-- 	sunit_grn_24,
-- 	sunit_grn_25
	
-- );

function end_deployment_phase()
	bm:out("Starting benchmark");
	army_tze_01:winds_of_magic_current();
	
	if bool_benchmark_mode then
		play_cutscene_intro();
	end;
	
	for i = 1, sunits_all:count() do
		local current_sunit = sunits_all:item(i);
		
		current_sunit.uc:change_behaviour_active("fire_at_will", true);
		current_sunit.uc:change_behaviour_active("skirmish", false);
	end;

	for i = 1, sunits_tze_all:count() do
		local current_sunit = sunits_tze_all:item(i);

		current_sunit.uc:set_invincible(true);
	end;

	sunit_grn_01.uc:set_invincible(true);
		
	bm:callback(
		function()
		
			sunits_grn_movement_1:goto_location_offset(0, 150, true, 130);
			--sunits_grn_movement_2:goto_location_offset(0, 1000, true, 150);

			sunit_tze_02.uc:perform_special_ability("wh_main_spell_fire_the_burning_head", sunit_grn_05.unit);
			sunit_tze_01.uc:perform_special_ability("wh3_main_lord_abilities_gaze_of_fate", sunit_grn_05.unit);

		end,
		0
	);

	bm:callback(
		function()

			--bm:spawn_vortex("barrier_base", v(-154.3, 50.8, 354.2), v(0.0, 0.0, 0.0));
			--bm:spawn_vortex("barrier_base", v(-252.2, 87.3, 193.0), v(0.0, 0.0, 0.0));
			bm:spawn_vortex("benchmark_barrier", v(-187.5, 60.8, 295.7), v(0.0, 0.0, 1.0))

		end,
		2500
	);

	bm:callback(
		function()

			bm:spawn_vortex("benchmark", v(-346.0, 58.0, 306.0), v(1.0, 0.0, 1.0));
			bm:spawn_vortex("benchmark", v(-174.0, 55.0, 495.0), v(1.0, 0.0, 1.0));

		end,
		12000
	);

	bm:callback(
		function()
		
			bm:spawn_vortex("benchmark", v(-254.0, 86.0, 186.0), v(1.0, 0.0, 1.0));
			bm:spawn_vortex("benchmark", v(-242.0, 83.0, 218.0), v(1.0, 0.0, 1.0));

			--bm:spawn_vortex("supernova_base", v(-279.8, 85.8, 223.9), v(0.0, 0.0, 0.0));

		end,
		13500
	);

	bm:callback(
		function()
		
			sunit_tze_14.uc:attack_unit(sunit_grn_01.unit, true, true);

		end,
		20000
	);

	bm:callback(
		function()

			sunits_tze_movement:goto_location_offset(0, -150, true, 130);

			bm:spawn_vortex("benchmark", v(-346.0, 58.0, 306.0), v(1.0, 0.0, 1.0));
			bm:spawn_vortex("benchmark", v(-174.0, 55.0, 495.0), v(1.0, 0.0, 1.0));
			bm:spawn_vortex("benchmark", v(-331.0, 86.0, 186.0), v(1.0, 0.0, 1.0));
			bm:spawn_vortex("benchmark", v(-311.0, 83.0, 218.0), v(1.0, 0.0, 1.0));

		end,
		40000
	);

	bm:callback(
		function()

			sunit_tze_01.uc:perform_special_ability("wh3_main_spell_tzeentch_pink_fire_of_tzeentch", sunit_grn_01.unit);
			
			bm:spawn_vortex("supernova_base", v(-257.6, 86.3, 183.9), v(0.0, 0.0, 0.0));

		end,
		46000
	)

	--- Unpausing Intel VTune Profiler ---
	-- 		common.VTune_pause_resume(false);
	--- Pausing Intel VTune Profiler ---
	-- 		common.VTune_pause_resume(true);
	
end;

--------------------------------------------------------------
------------------------- cutscene ---------------------------
--------------------------------------------------------------

cutscene_intro = cutscene:new(
	"cutscene_intro", 							-- unique string name for cutscene
	uc_tze_01_all, 								-- unitcontroller over player's army
	63000, 										-- duration of cutscene in ms
	function() bm:end_benchmark() end 			-- what to call when cutscene is finished
);

cam = cutscene_intro:camera();
cutscene_intro:set_skippable(false, nil);
--cutscene_intro:set_debug();

function play_cutscene_intro()
	cutscene_intro:action(function() cam:fade(false, 0.5) end, 0);
	
	--  / Rename Shots                                                                        
	cutscene_intro:action(function() cam:move_to(v(-176.470718,154.841736,444.597931),v(-119.922043,-109.594543,59.414948), 0, true, -1) end, 0);
	cutscene_intro:action(function() cam:move_to(v(-172.223404,85.841736,378.734711),v(-139.717926,-94.685867,-54.659607), 12, true, -1) end, 1500);
	cutscene_intro:action(function() cam:move_to(v(-144.961212,108.930458,141.172775),v(-298.025818,34.314194,580.157654), 0, true, -1) end, 14000);
	cutscene_intro:action(function() cam:move_to(v(-137.377792,163.303894,145.302277),v(-275.611572,-194.507111,418.372833), 5, true, -1) end, 16000);
	cutscene_intro:action(function() cam:move_to(v(-226.67012,95.303894,157.982056),v(-114.5093,44.292171,612.422852), 6, true, -1) end, 20000);
	cutscene_intro:action(function() cam:move_to(v(-129.098511,75.303894,219.507172),v(-143.498123,67.890411,690.045044), 12, true, -1) end, 26000);
	cutscene_intro:action(function() cam:move_to(v(-32.834408,115.007576,385.271698),v(-440.961212,-78.324379,252.198914), 5, true, -1) end, 38000);
	-- cutscene_intro:action(function() cam:move_to(v(-143.109909,66.337425,313.305634),v(-263.437836,26.175991,-140.022552), 10, true, -1) end, 43000);
	cutscene_intro:action(function() cam:move_to(v(-187.19574,85.337425,388.995117),v(-294.006958,-49.866783,-49.03006), 10, true, -1) end, 43000);

	-- cutscene_intro:action(function() cam:move_to(v(-103.629082,122.098122,326.310974),v(-361.644043,-141.144714,33.520233), 6, true, -1) end, 54000);
	cutscene_intro:action(function() cam:move_to(v(-173.346802,126.337433,441.470367),v(-222.374786,-127.155212,47.9086), 6, true, -1) end, 54000);

	cutscene_intro:action(function() cam:fade(true, 0.5) end, 63000);
	
	cutscene_intro:start();	
end;