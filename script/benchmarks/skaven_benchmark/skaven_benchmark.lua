load_script_libraries();

bool_benchmark_mode = false;

if bm:is_benchmarking_mode() then
	bool_benchmark_mode = true;
end;

bm:setup_battle(function() end_deployment_phase() end);

alliances = bm:alliances();

alliance_skv = alliances:item(1);
army_skv_01 = alliance_skv:armies():item(1);

alliance_lzd = alliances:item(2); 
army_lzd_01 = alliance_lzd:armies():item(1);

-- Skaven = sunit_skv --

sunit_skv_01 = script_unit:new_by_reference(army_skv_01, "skv_01");
sunit_skv_02 = script_unit:new_by_reference(army_skv_01, "skv_02");
sunit_skv_03 = script_unit:new_by_reference(army_skv_01, "skv_03");
sunit_skv_04 = script_unit:new_by_reference(army_skv_01, "skv_04");
sunit_skv_05 = script_unit:new_by_reference(army_skv_01, "skv_05");
sunit_skv_06 = script_unit:new_by_reference(army_skv_01, "skv_06");
sunit_skv_07 = script_unit:new_by_reference(army_skv_01, "skv_07");
sunit_skv_08 = script_unit:new_by_reference(army_skv_01, "skv_08");
sunit_skv_09 = script_unit:new_by_reference(army_skv_01, "skv_09");
sunit_skv_10 = script_unit:new_by_reference(army_skv_01, "skv_10");
sunit_skv_11 = script_unit:new_by_reference(army_skv_01, "skv_11");
sunit_skv_12 = script_unit:new_by_reference(army_skv_01, "skv_12");
sunit_skv_13 = script_unit:new_by_reference(army_skv_01, "skv_13");
sunit_skv_14 = script_unit:new_by_reference(army_skv_01, "skv_14");
sunit_skv_15 = script_unit:new_by_reference(army_skv_01, "skv_15");
sunit_skv_16 = script_unit:new_by_reference(army_skv_01, "skv_16");
sunit_skv_17 = script_unit:new_by_reference(army_skv_01, "skv_17");
sunit_skv_18 = script_unit:new_by_reference(army_skv_01, "skv_18");
sunit_skv_19 = script_unit:new_by_reference(army_skv_01, "skv_19");
sunit_skv_20 = script_unit:new_by_reference(army_skv_01, "skv_20");
sunit_skv_21 = script_unit:new_by_reference(army_skv_01, "skv_21");
sunit_skv_22 = script_unit:new_by_reference(army_skv_01, "skv_22");

uc_skv_01_all = unitcontroller_from_army(army_skv_01);
uc_skv_01_all:take_control();

-- Lizardmen = sunit_lzd --

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
sunit_lzd_21 = script_unit:new_by_reference(army_lzd_01, "lzd_21");

uc_lzd_01_all = unitcontroller_from_army(army_lzd_01);
uc_lzd_01_all:take_control();

sunits_all = script_units:new(
	"all",
	sunit_skv_01,
	sunit_skv_02,
	sunit_skv_03,
	sunit_skv_04,
	sunit_skv_05,
	sunit_skv_06,
	sunit_skv_07,
	sunit_skv_08,
	sunit_skv_09,
	sunit_skv_10,
	sunit_skv_11,
	sunit_skv_12,
	sunit_skv_13,
	sunit_skv_14,
	sunit_skv_15,
	sunit_skv_16,
	sunit_skv_17,
	sunit_skv_18,
	sunit_skv_19,
	sunit_skv_20,
	sunit_skv_21,
	sunit_skv_22,
	sunit_lzd_01,
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
	sunit_lzd_21
	
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
	
	------------------------
	-- Skaven lord attack --
	------------------------
	
	bm:callback(
		function()
		
			sunit_skv_01.uc:attack_unit(sunit_lzd_05.unit, true, true);

		end,
		100
	);
	
	-------------------------------
	-- Infantry / Monster attack --
	-------------------------------
	
	bm:callback(
		function()
			
			-- Skaven Infantry --
			sunit_skv_02.uc:attack_unit(sunit_lzd_07.unit, true, true);
			sunit_skv_03.uc:attack_unit(sunit_lzd_06.unit, true, true);
			sunit_skv_04.uc:attack_unit(sunit_lzd_05.unit, true, true);
			sunit_skv_05.uc:attack_unit(sunit_lzd_04.unit, true, true);
			sunit_skv_06.uc:attack_unit(sunit_lzd_03.unit, true, true);
			sunit_skv_07.uc:attack_unit(sunit_lzd_02.unit, true, true);
			sunit_skv_08.uc:attack_unit(sunit_lzd_07.unit, true, true);
			sunit_skv_09.uc:attack_unit(sunit_lzd_06.unit, true, true);
			sunit_skv_10.uc:attack_unit(sunit_lzd_05.unit, true, true);
			sunit_skv_11.uc:attack_unit(sunit_lzd_04.unit, true, true);
			sunit_skv_12.uc:attack_unit(sunit_lzd_03.unit, true, true);
			sunit_skv_13.uc:attack_unit(sunit_lzd_02.unit, true, true);
			
			-- Skaven Monsters --
			sunit_skv_16.uc:attack_unit(sunit_lzd_03.unit, true, true);
			sunit_skv_17.uc:attack_unit(sunit_lzd_05.unit, true, true);
			sunit_skv_18.uc:attack_unit(sunit_lzd_07.unit, true, true);

		end,
		100
	);
	
	----------------------------------
	-- Missile and Artillery Attack --
	----------------------------------
	
	bm:callback(
		function()	
			
			sunit_skv_14.uc:attack_unit(sunit_lzd_02.unit, true, true);
			sunit_skv_15.uc:attack_unit(sunit_lzd_02.unit, true, true);
			sunit_skv_19.uc:attack_unit(sunit_lzd_06.unit, true, true);
			sunit_skv_20.uc:attack_unit(sunit_lzd_05.unit, true, true);
			
		end,
		50
	);
	
	
	bm:callback(
		function()
		
			-- Lizardmen infantry charge -- 
			sunit_lzd_02.uc:attack_unit(sunit_skv_07.unit, true, true);
			sunit_lzd_03.uc:attack_unit(sunit_skv_06.unit, true, true);
			sunit_lzd_04.uc:attack_unit(sunit_skv_05.unit, true, true);
			sunit_lzd_05.uc:attack_unit(sunit_skv_04.unit, true, true);
			sunit_lzd_06.uc:attack_unit(sunit_skv_03.unit, true, true);
			sunit_lzd_07.uc:attack_unit(sunit_skv_02.unit, true, true);
			sunit_lzd_08.uc:attack_unit(sunit_skv_03.unit, true, true);
			sunit_lzd_09.uc:attack_unit(sunit_skv_04.unit, true, true);
			sunit_lzd_10.uc:attack_unit(sunit_skv_05.unit, true, true);
			sunit_lzd_11.uc:attack_unit(sunit_skv_05.unit, true, true);
			sunit_lzd_12.uc:attack_unit(sunit_skv_03.unit, true, true);
			sunit_lzd_15.uc:attack_unit(sunit_skv_07.unit, true, true);
			sunit_lzd_16.uc:attack_unit(sunit_skv_05.unit, true, true);
		
		end,
		50
	);
	
	----------------------------------------------
	-- Lizardmen monster / cavalry units charge --
	----------------------------------------------
	
	bm:callback(
		function()
		
			sunit_lzd_01.uc:attack_unit(sunit_skv_05.unit, true, true);
			sunit_lzd_13.uc:attack_unit(sunit_skv_06.unit, true, true);
			sunit_lzd_14.uc:attack_unit(sunit_skv_07.unit, true, true);
			sunit_lzd_17.uc:attack_unit(sunit_skv_05.unit, true, true);
			sunit_lzd_18.uc:attack_unit(sunit_skv_15.unit, true, true);
			sunit_lzd_19.uc:attack_unit(sunit_skv_06.unit, true, true);
			sunit_lzd_20.uc:attack_unit(sunit_skv_06.unit, true, true);
			sunit_lzd_21.uc:attack_unit(sunit_skv_05.unit, true, true);

		end,
		500
	);
	
	--------------------------
	-- Skaven spell casters --
	--------------------------
	
	bm:callback(
		function()
			
			sunit_skv_21.uc:perform_special_ability("wh2_main_spell_plague_plague", sunit_lzd_05.unit);
			--sunit_skv_22.uc:perform_special_ability("wh2_main_spell_plague_the_dreaded_thirteenth_spell", sunit_lzd_08.unit);
		
		end,
		20000
	);
	
	----------------------------
	-- Lizardmen spell caster --
	----------------------------
	
	bm:callback(
		function()
		
			sunit_lzd_21.uc:perform_special_ability("wh2_main_spell_high_magic_tempest", sunit_skv_05.unit);
		
		end,
		23000
	);
	
end;

--------------------------------------------------------------
------------------------- cutscene ---------------------------
--------------------------------------------------------------

cutscene_intro = cutscene:new(
	"cutscene_intro", 							-- unique string name for cutscene
	uc_skv_01_all, 								-- unitcontroller over player's army
	64000, 										-- duration of cutscene in ms
	function() bm:end_benchmark() end 			-- what to call when cutscene is finished
);

cam = cutscene_intro:camera();
cutscene_intro:set_skippable(false, nil);
--cutscene_intro:set_debug();

function play_cutscene_intro()
	cutscene_intro:action(function() cam:fade(false, 0.5) end, 0);
	
	-- Initial Set-up Cam /                                                                         Time 00:03 - 00:13 -- 
	cutscene_intro:action(function() cam:move_to(v(-417.53775,443.024933,-136.761536),v(-262.38504,363.34317,18.652634), 0, true, -1) end, 0);
	cutscene_intro:action(function() cam:move_to(v(-364.243286,388.345032,-117.051003),v(-203.320267,336.970154,44.316673), 8, true, -1) end, 0);
	
	-- Armies Clash /                                                                        		Time 00:13 - 00:31  --
	cutscene_intro:action(function() cam:move_to(v(-398.061829,383.653229,-7.963822),v(-178.400208,330.403748,51.097248), 6, true, -1) end, 10000);
	cutscene_intro:action(function() cam:move_to(v(-365.388611,382.661865,4.902042),v(-169.754562,255.115387,10.732197), 6, true, -1) end, 17000);

	-- pan  /                                               										Time 00:31 - 00:42 -- 
	cutscene_intro:action(function() cam:move_to(v(-254.129501,395.84433,8.273458),v(-79.125839,253.839706,-53.233139), 6, true, -1) end, 20000);
	cutscene_intro:action(function() cam:move_to(v(-123.63665,397.507294,-42.73156),v(-291.327911,266.65625,53.873154), 0, true, -1) end, 28000);
	
	-- pan in other direction  /                                                               		Time 00:42 - 00:53 --
	cutscene_intro:action(function() cam:move_to(v(-3.667906,398.081512,-26.673399),v(-197.708069,276.243286,18.919687), 6, true, -1) end, 40000);
	cutscene_intro:action(function() cam:move_to(v(-320.552856,380.749023,4.484997),v(-104.159409,295.266235,25.501261), 8, true, -1) end, 46000);
	
	cutscene_intro:action(function() cam:fade(true, 0.5) end, 64000);
	
	cutscene_intro:start();	
end;