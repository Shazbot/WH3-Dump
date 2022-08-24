function Play_EGX_Intro()
	bm:out("Play_EGX_Intro() called");
	
	POS_Cam_Cutscene_Intro_Final = v(-276.967316,133.536041,-584.04364);
	Targ_Cam_Cutscene_Intro_Final = v(-277.32135,106.466652,-502.899719);	
	General_Speech = new_sfx("Play_DWF_Thor_GS_Qbattle_prelude_high_king_vs_Grnskns_v2");
	Jack_Fun_Start = new_sfx("EGX_Audio_Cinematic_Start");
	Jack_Fun_End = new_sfx("EGX_Audio_Cinematic_End");
	
	local Cutscene_Intro = cutscene:new(
		"Cutscene_Intro", 							-- unique string name for cutscene
		ga_player_01:get_unitcontroller(),			-- unitcontroller over player's army
		47000 										-- duration of cutscene in ms
	);	

	Cutscene_Intro:set_skippable(true, function() Skip_Cutscene_Intro() end);
	Cutscene_Intro:set_skip_camera(POS_Cam_Cutscene_Intro_Final, Targ_Cam_Cutscene_Intro_Final);
	--Cutscene_Intro:set_debug();
	

	cam = Cutscene_Intro:camera();
	
	Cutscene_Intro:action(function() cam:fade(false, 1) end, 2000);
	Cutscene_Intro:action(function() bm:enable_unit_ids(false) end, 0);
	Cutscene_Intro:action(function() play_sound(Jack_Fun_Start) end, 0);
	Cutscene_Intro:action(function() bm:suppress_unit_voices(true) end, 0);
	
	-- opening
	Cutscene_Intro:action(function() cam:move_to(v(-244.561081,116.886795,-722.33429),v(-257.817993,126.604782,-806.280396), 0, false, 40) end, 0);
	Cutscene_Intro:action(function() cam:move_to(v(-286.737457,112.6418,-660.701904),v(-286.482452,122.374374,-745.686218), 14, false, 40) end, 0);
	
	Cutscene_Intro:action(function() Cutscene_Intro:play_sound(General_Speech) end, 6000);
	Cutscene_Intro:action(function() ga_player_01:play_sound_taunt() end, 6000);
	
	-- wide shot of army
	Cutscene_Intro:action(function() cam:move_to(v(-337.625488,146.168137,-662.852356),v(-312.649475,131.077179,-582.443115), 0, false, 65) end, 6000);
	Cutscene_Intro:action(function() cam:move_to(v(-288.65274,146.168137,-617.211548),v(-289.296936,131.079941,-533.014771), 16, false, -1) end, 6000);
	
	-- thorgrim
	Cutscene_Intro:action(function() cam:move_to(v(-306.366821,113.141602,-501.2742),v(-266.969055,90.055374,-571.651062), 0, false, -1) end, 10000);
	Cutscene_Intro:action(function() cam:move_to(v(-306.042999,112.361115,-499.72464),v(-291.914154,98.721977,-582.981079), 8, false, -1) end, 10000);
	
	-- slayers
	Cutscene_Intro:action(function() cam:move_to(v(-238.819489,114.028175,-516.806702),v(-211.620667,71.397141,-585.799866), 0, false, -1) end, 14000);
	Cutscene_Intro:action(function() cam:move_to(v(-239.691971,113.336929,-519.137817),v(-197.278458,72.611832,-581.265076), 10, false, -1) end, 14000);
	
	-- warriors
	Cutscene_Intro:action(function() cam:move_to(v(-284.229187,111.339073,-512.035583),v(-256.038818,70.794083,-581.88269), 0, false, -1) end, 17000);
	Cutscene_Intro:action(function() cam:move_to(v(-284.59137,111.34111,-515.444092),v(-247.767349,71.926926,-581.8349), 20, false, -1) end, 17000);
	
	Cutscene_Intro:action(function() ga_player_01:play_sound_taunt() end, 17000);
	
	-- waterfalls
	Cutscene_Intro:action(function() cam:move_to(v(-266.023956,128.490692,-101.935783),v(-202.863449,130.730331,-44.290497), 0, false, -1) end, 22000);
	Cutscene_Intro:action(function() cam:move_to(v(-244.897293,128.490692,0.150781),v(-169.699219,140.824112,39.014381), 14, false, -1) end, 22000);
	
	-- orc entry point
	Cutscene_Intro:action(function() cam:move_to(v(-199.20314,132.850464,-239.370636),v(-122.734116,133.387283,-277.704224), 0, false, -1) end, 25000);
	Cutscene_Intro:action(function() cam:move_to(v(-199.20314,132.850464,-239.370636),v(-126.385307,128.038742,-283.998871), 8, false, -1) end, 25000);
	
	-- buildings
	Cutscene_Intro:action(function() cam:move_to(v(-306.738037,116.680351,-343.19165),v(-390.037109,117.314621,-323.746979), 0, false, -1) end, 28000);
	Cutscene_Intro:action(function() cam:move_to(v(-394.646179,109.427307,-228.616531),v(-490.576996,126.827042,-196.590118), 15, false, -1) end, 28000);
	
	-- orc buildings
	--Cutscene_Intro:action(function() cam:move_to(v(-403.674713,144.591339,-122.305412),v(-486.173218,123.630356,-130.787735), 0, false, -1) end, 34000);
	--Cutscene_Intro:action(function() cam:move_to(v(-420.462219,144.191315,-165.734436),v(-496.26944,105.168282,-172.647995), 14, false, -1) end, 34000);
	
	-- thane
	Cutscene_Intro:action(function() cam:move_to(v(-294.523163,111.040459,-505.935822),v(-367.80011,100.36232,-548.75769), 0, false, -1) end, 34000);
	Cutscene_Intro:action(function() cam:move_to(v(-293.478546,111.045944,-506.685242),v(-373.750214,102.362854,-534.939636), 8, false, -1) end, 34000);
	
	Cutscene_Intro:action(function() ga_player_01:play_sound_taunt() end, 35000);
	
	-- thorgrim
	Cutscene_Intro:action(function() cam:move_to(v(-304.008728,110.669853,-499.083984),v(-254.958847,94.384453,-567.246521), 0, false, -1) end, 37000);
	Cutscene_Intro:action(function() cam:move_to(v(-313.373291,110.410172,-499.655243),v(-256.806824,103.972855,-563.499207), 14, false, -1) end, 37000);
	
	Cutscene_Intro:action(function() ga_player_01:play_sound_charge() end, 43500);
	
	-- thorgrim
	--Cutscene_Intro:action(function() cam:move_to(v(-313.791534,114.924835,-495.550171),v(-261.596832,91.071335,-558.984985), 0, true, -1) end, 45000);
	Cutscene_Intro:action(function() cam:move_to(POS_Cam_Cutscene_Intro_Final, Targ_Cam_Cutscene_Intro_Final, 2, false, -1) end, 45000);
	
	Cutscene_Intro:action(function() play_sound(Jack_Fun_End) end, 46000);
	Cutscene_Intro:action(function() bm:suppress_unit_voices(false) end, 46000);
	

	Cutscene_Intro:start();
end;


function Skip_Cutscene_Intro()	
	cam:fade(true, 0);
	
	stop_sound(General_Speech);
	stop_sound(Jack_Fun_Start);
	play_sound(Jack_Fun_End);
	bm:suppress_unit_voices(false);
	
	bm:callback(
		function()
			cam:fade(false, 0.5)
			bm:enable_unit_ids(true);
		end,
		1000
	);
end;