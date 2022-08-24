gb = generated_battle:new(
	false,                                      		-- screen starts black
	false,                                     			-- prevent deployment for player
	false,                                     			-- prevent deployment for ai
	function() gb:start_generated_cutscene(gc) end, 	-- intro cutscene function
	false                                      			-- debug mode
);

gc = generated_cutscene:new(true);

gc:set_wh2_subtitles();

ga_player = gb:get_army(gb:get_player_alliance_num(), 1);