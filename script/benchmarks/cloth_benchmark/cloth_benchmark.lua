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
sunit_ksl_01A = script_unit:new_by_reference(army_ksl_01, "ksl_01A");
sunit_ksl_01B = script_unit:new_by_reference(army_ksl_01, "ksl_01B");
sunit_ksl_01C = script_unit:new_by_reference(army_ksl_01, "ksl_01C");
sunit_ksl_01D = script_unit:new_by_reference(army_ksl_01, "ksl_01D");
sunit_ksl_01E = script_unit:new_by_reference(army_ksl_01, "ksl_01E");
sunit_ksl_01F = script_unit:new_by_reference(army_ksl_01, "ksl_01F");
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

uc_kho_01_all = unitcontroller_from_army(army_kho_01);
uc_kho_01_all:take_control();

sunits_all = script_units:new(
	"all",
	sunit_ksl_01,
	sunit_ksl_01A,
	sunit_ksl_01B,
	sunit_ksl_01C,
	sunit_ksl_01D,
	sunit_ksl_01E,
	sunit_ksl_01F,
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
	sunit_kho_20
	
);

sunits_kislev_movement = script_units:new(
	"ksl_movement",
	sunit_ksl_01,
	sunit_ksl_01A,
	sunit_ksl_01B,
	sunit_ksl_01C,
	sunit_ksl_01D,
	sunit_ksl_01E,
	sunit_ksl_01F,
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
	sunit_ksl_20

);

sunits_kislev_inf_movement = script_units:new(
	"ksl_inf_movement",
	sunit_ksl_03,
	sunit_ksl_04,
	sunit_ksl_05,
	sunit_ksl_06,
	sunit_ksl_10,
	sunit_ksl_11
);

sunits_kislev_missile_movement = script_units:new(
	"ksl_missile_movement",
	sunit_ksl_07,
	sunit_ksl_08,
	sunit_ksl_09

);

sunits_kislev_heroes_lords_movement = script_units:new(
	"ksl_heroes_lords_movement",
	sunit_ksl_01,
	sunit_ksl_01A,
	sunit_ksl_01B,
	sunit_ksl_01C,
	sunit_ksl_01D,
	sunit_ksl_01E,
	sunit_ksl_01F,
	sunit_ksl_02

);
	

sunits_khorne_movement = script_units:new(
	"kho_movement",
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
	sunit_kho_17
	
);

sunits_khorne_inf_movement = script_units:new(
	"kho_inf_movement",
	sunit_kho_04,
	sunit_kho_05,
	sunit_kho_06,
	sunit_kho_07,
	sunit_kho_08,
	sunit_kho_09,
	sunit_kho_10,
	sunit_kho_11,
	sunit_kho_15,
	sunit_kho_16
	
);

sunits_khorne_inf2_movement = script_units:new(
	"kho_inf2_movement",
	sunit_kho_04,
	sunit_kho_05

);

sunits_khorne_lord_and_large_movement = script_units:new(
	"kho_lord_and_large_movement",
	sunit_kho_01,
	sunit_kho_02,
	sunit_kho_03,
	sunit_kho_17

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
		
			--- Marching Kislev Forward ---
			sunits_kislev_movement:goto_location_offset(0, 30, false, -90);
			
			-- Khorne Marching Forward --
			sunits_khorne_movement:goto_location_offset(0, 40, false, 90);
			
			-- Khorne Lord & Soul Grinder Marching Forward --
			sunits_khorne_lord_and_large_movement:goto_location_offset(0, 150, false, 90);

		end,
		0
	);
	
	
	bm:callback(
		function()
			
			--- Kislev missle troops activate fire at will ---
			sunit_ksl_07.uc:change_behaviour_active("fire_at_will", true);
			sunit_ksl_08.uc:change_behaviour_active("fire_at_will", true);
			sunit_ksl_09.uc:change_behaviour_active("fire_at_will", true);
			
		end,
		10000
	);
	
	bm:callback(
		function()
			
			-- Khislev Infantry Charging Forward --
			sunits_kislev_inf_movement:goto_location_offset(0, 140, true, -90);
			sunits_kislev_missile_movement:goto_location_offset(0, 130, true, -90);
			sunits_kislev_heroes_lords_movement:goto_location_offset(0, 140, true, -90);
		
		end,
		12500
	);

	bm:callback(
		function()
			
			-- Khorne Infantry Charging Forward --
			sunits_khorne_inf_movement:goto_location_offset(0, 130, true, 90);
			
			
		end,
		14000
	);
	
	bm:callback(
		function()
			
			--- Kislev Artillery Attack Orders ---
			sunit_ksl_19.uc:attack_unit(sunit_kho_04.unit, true, true);
			sunit_ksl_20.uc:attack_unit(sunit_kho_07.unit, true, true);
		
		end,
		20000
	);
	
	bm:callback(
		function()
		
			--- Khorne Lord Buffing Himself --- 
			sunit_kho_01.uc:perform_special_ability("wh3_main_lord_abilities_rage_embodied", sunit_kho_01.unit);
		
		end,
		32000
	);
	
	bm:callback(
		function()
			
			--- Snow Leapord / Missile Cav Flank ---
			sunit_ksl_17.uc:attack_unit(sunit_kho_16.unit, true, true);
			sunit_ksl_18.uc:attack_unit(sunit_kho_16.unit, true, true);
			sunit_ksl_15.uc:attack_unit(sunit_kho_16.unit, true, true);
			
			-- Elemental bear charing soul grinder --
			sunit_ksl_16.uc:attack_unit(sunit_kho_17.unit, true, true);
			
		end,
		42000
	);
	
	
	bm:callback(
		function()

			--- Khorne Artillery Attack Orders ---
			sunit_kho_19.uc:attack_unit(sunit_ksl_03.unit, true, true);
			sunit_kho_20.uc:attack_unit(sunit_ksl_10.unit, true, true);
			
		end,
		50000
	);
	
	bm:callback(
		function()
		
			--- Kislev Infantry Attack Orders ---
			sunit_ksl_03.uc:attack_unit(sunit_kho_01.unit, true, true);
			sunit_ksl_04.uc:attack_unit(sunit_kho_10.unit, true, true);
			sunit_ksl_05.uc:attack_unit(sunit_kho_11.unit, true, true);
			sunit_ksl_06.uc:attack_unit(sunit_kho_07.unit, true, true);
			sunit_ksl_10.uc:attack_unit(sunit_kho_15.unit, true, true);
			sunit_ksl_11.uc:attack_unit(sunit_kho_17.unit, true, true);
		
			--- Khorne Infantry Attack Orders ---
			sunit_kho_06.uc:attack_unit(sunit_ksl_06.unit, true, true);		
			sunit_kho_07.uc:attack_unit(sunit_ksl_06.unit, true, true);
			sunit_kho_08.uc:attack_unit(sunit_ksl_06.unit, true, true);
			sunit_kho_09.uc:attack_unit(sunit_ksl_06.unit, true, true);
			sunit_kho_10.uc:attack_unit(sunit_ksl_04.unit, true, true);
			sunit_kho_11.uc:attack_unit(sunit_ksl_05.unit, true, true);
			sunit_kho_15.uc:attack_unit(sunit_ksl_10.unit, true, true);
			
			-- Khorne Lord Casting Spell at Infantry --
			sunit_kho_01.uc:perform_special_ability("wh3_main_lord_abilities_bellow_of_endless_fury", sunit_ksl_03.unit);
			
		end,
		57000
	);
	
	bm:callback(
		function()
		
		--- Khorne Lord Attack Order ---
			sunit_kho_01.uc:attack_unit(sunit_ksl_03.unit, true, true);
			
		--- Khorne second wave infantry march -- 
		sunits_khorne_inf2_movement:goto_location_offset(0, 40, false, 90);
		
		end,
		61000
	);
	
	
	bm:callback(
		function()			
			--- Kislev Lord Casting Spell ---
			sunit_ksl_01.uc:perform_special_ability("wh3_main_spell_ice_ice_sheet", sunit_kho_04.unit);
			
			--- Unpausing Intel VTune Profiler ---
			common.VTune_pause_resume(false);

		end,
		66000
	);
	
	bm:callback(
		function()
		
			--- Pausing Intel VTune Profiler ---
			common.VTune_pause_resume(true);
			
		end,
		71000
	);
	
	bm:callback(
		function()
		
			--- Kislev Ice Maiden Casting Spell ---
			sunit_ksl_02.uc:perform_special_ability("wh3_main_spell_tempest_hailstorm", sunit_kho_17.unit);
			
			--- Changing Kislev Artillery To Fire At Will --- 
			sunit_ksl_19.uc:change_behaviour_active("fire_at_will", true);
			sunit_ksl_20.uc:change_behaviour_active("fire_at_will", true);
			
		end,
		74000
	);
	
	bm:callback(
		function()
		
			--- Teleport cav into flanking position --- 
			sunit_ksl_12.uc:teleport_to_location(v(-94.5, -140.6), 100, 32.0)
			sunit_ksl_13.uc:teleport_to_location(v(-79.5, -97.3), 100, 32.0)
			
			--- Khorne Artillery Orders ---
			sunit_kho_19.uc:attack_unit(sunit_ksl_07.unit, true, true);
			sunit_kho_20.uc:attack_unit(sunit_ksl_09.unit, true, true);
			
		end,
		86000
	);
	
	
	bm:callback(
		function()
		
			--- Final Kislev Cav Flank Charge --- 
			sunit_ksl_12.uc:attack_unit(sunit_kho_04.unit, true, true);
			sunit_ksl_13.uc:attack_unit(sunit_kho_05.unit, true, true);
			
		end,
		86000
	);
	
end;

--------------------------------------------------------------
------------------------- cutscene ---------------------------
--------------------------------------------------------------

cutscene_intro = cutscene:new(
	"cutscene_intro", 							-- unique string name for cutscene
	uc_ksl_01_all, 								-- unitcontroller over player's army
	102000, 										-- duration of cutscene in ms
	function() bm:end_benchmark() end 			-- what to call when cutscene is finished
);

cam = cutscene_intro:camera();
cutscene_intro:set_skippable(false, nil);
--cutscene_intro:set_debug();

function play_cutscene_intro()
	cutscene_intro:action(function() cam:fade(false, 0.5) end, 0);
	
	--  / Opening Shot & Slow Pan Towards Kislev Army.                                                                         
	cutscene_intro:action(function() cam:move_to(v(247.514832,510.823425,-307.190704),v(79.995193,337.869873,-174.675674), 0, true, -1) end, 0);
	cutscene_intro:action(function() cam:move_to(v(169.050995,419.682922,-213.147919),v(-86.973633,327.666565,-174.156128), 11, true, -1) end, 5000);
	cutscene_intro:action(function() cam:move_to(v(152.222137,413.682922,-193.273697),v(-55.379562,334.867981,-355.217468), 4, true, -1) end, 16000);
	cutscene_intro:action(function() cam:move_to(v(145.571457,413.682922,-194.641342),v(-121.906906,361.587372,-230.382965), 4, true, -1) end, 18500);
	
	--  / Broad Pan Over Towards Khorne Army & Artillery Impact.     
	cutscene_intro:action(function() cam:move_to(v(-22.08193,429.686584,-203.894455),v(-276.782074,326.615906,-197.557693), 6, true, -1) end, 20000);
	cutscene_intro:action(function() cam:move_to(v(-92.849365,427.686584,-133.537399),v(-223.2901,316.228516,-348.242859), 4, true, -1) end, 23500);
	
	-- / Rotate Around Khorne Lord. 
	cutscene_intro:action(function() cam:move_to(v(-104.447594,425.686584,-230.714081),v(82.50956,292.106628,-381.510468), 4, true, -1) end, 25000);
	cutscene_intro:action(function() cam:move_to(v(-58.732685,418.686584,-279.118713),v(-142.627563,322.803162,-35.594284), 4, true, -1) end, 29000);
	
	-- / Zoom Out. 
	cutscene_intro:action(function() cam:move_to(v(-117.269646,468.686584,-346.775146),v(47.62281,325.489868,-179.91803), 5, true, -1) end, 35000);

	--  / Following Khorne Army While March & Zooming Into Front Line Forces.    
	cutscene_intro:action(function() cam:move_to(v(-41.743382,459.730072,-341.577423),v(114.796082,317.583801,-166.004257), 13, true, -1) end, 36000);
	cutscene_intro:action(function() cam:move_to(v(-38.657627,426.644897,-348.205414),v(103.579132,304.790436,-147.067856), 8, true, -1) end, 49000);
	
	-- / Pan Across Infantry Clashing & Stopping Overhead.
	cutscene_intro:action(function() cam:move_to(v(-9.682206,433.111664,-305.445007),v(43.125824,280.607513,-82.98172), 4, true, -1) end, 57000);
	cutscene_intro:action(function() cam:move_to(v(45.828362,444.282288,-223.983734),v(-101.365288,261.129791,-81.416794), 5, true, -1) end, 62000);
	
	-- / Zoom In
	cutscene_intro:action(function() cam:move_to(v(34.914974,422.53653,-220.170425),v(-181.430573,360.499176,-62.431), 4, true, -1) end, 66000);
	cutscene_intro:action(function() cam:move_to(v(36.416309,421.53653,-197.775864),v(-213.543762,371.363617,-300.432892), 5, true, -1) end, 71000);
	cutscene_intro:action(function() cam:move_to(v(33.447334,420.53653,-197.954529),v(-186.915405,365.836182,-352.823578), 4, true, -1) end, 75000);
	
	-- / Panning Towards Hailstorm Spell & Pivoting To Get Rest of Battle In View.
	cutscene_intro:action(function() cam:move_to(v(27.778833,444.670319,-29.62044),v(-89.097778,279.525208,-215.639343), 6, true, -1) end, 76500);
	cutscene_intro:action(function() cam:move_to(v(-69.399185,443.665344,-140.654739),v(132.414322,290.564087,-247.272888), 10, true, -1) end, 82000);
	
	-- / Final Pan Out Over Forces.
	cutscene_intro:action(function() cam:move_to(v(-16.982582,429.665344,-160.233154),v(211.310974,303.27887,-246.515793), 8, true, -1) end, 93000);
	
	cutscene_intro:action(function() cam:fade(true, 0.5) end, 102000);
	
	cutscene_intro:start();	
end;