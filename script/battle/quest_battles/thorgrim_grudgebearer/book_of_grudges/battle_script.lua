-- Thorgrim, Book of Grudges, Defender
load_script_libraries();

bm = battle_manager:new(empire_battle:new());

gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	true,                                      	-- prevent deployment for ai
	nil,										-- intro cutscene function
	false                                      	-- debug mode
);

-------ARMY SETUP-------
ga_player_01 = gb:get_army(gb:get_player_alliance_num(), 1); -- Player Defenders
ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(), 1); -- Initial Attacker

-------OBJECTIVES-------
gb:set_objective_on_message("battle_started", "wh_main_qb_objective_defend_defeat_army_ambush");


-------ORDERS-------
ga_ai_01:attack_on_message("generated_custscene_ended");


-------HINTS-------
gb:queue_help_on_message("generated_custscene_ended", "wh_main_qb_dwf_thorgrim_grudgebearer_book_of_grudges_stage_3_hint_objectives", 13000, 2000, 4000);


-------VICTORY CONDITIONS-------

-------GENERALS SPEECH-------
local index = 0;
local current_sound;
local current_subtitle;
local elements =
{
	{"Play_DWF_Thor_GS_Qbattle_prelude_book_grudges_pt_01", "wh_main_qb_dwf_thorgrim_grudgebearer_book_of_grudges_stage_3_pt_01"},
	{"Play_DWF_Thor_GS_Qbattle_prelude_book_grudges_pt_02", "wh_main_qb_dwf_thorgrim_grudgebearer_book_of_grudges_stage_3_pt_02"},
	{"Play_DWF_Thor_GS_Qbattle_prelude_book_grudges_pt_03", "wh_main_qb_dwf_thorgrim_grudgebearer_book_of_grudges_stage_3_pt_03"},
	{"Play_DWF_Thor_GS_Qbattle_prelude_book_grudges_pt_04", "wh_main_qb_dwf_thorgrim_grudgebearer_book_of_grudges_stage_3_pt_04"}
};
local subtitles = bm:subtitles()
local player_army = gb:get_army(gb:get_player_alliance_num(), 1);
local player_commander = player_army:get_first_scriptunit();
local cam = bm:camera();

-- This is triggered to cause the initial speech update function to fire.
gb:add_listener(
	"battle_started", 
	function()
		print("Initialised Quest Battle Ambush Cutscene");
		cam:allow_user_to_skip_ambush_intro(true);
		cam:teleport_defender_when_ambush_intro_skipped(true);
		
		-- Represents the initial wait time of the cutscene.
		gb:message_on_time_offset("speech_update", 4000, true);
	end, 
	true
);

-- This is where the vo and subtitles play. It's calls itself recursivley until it exits.
gb:add_listener(
	"speech_update",
	function()
		-- Early exit if the player has pressed escape or the ambush cutscene has stopped executing.
		if not cam:is_ambush_controller_executing() then
			-- If we've reached the end then clean up.
			print("End: Skipped Cutscene");
			gb:remove_listener("speech_update");
			gb:message_on_time_offset("generated_custscene_ended", 2000, true);
			subtitles:clear();
		else
			if is_nil(current_sound) or (is_battlesoundeffect(current_sound) and not current_sound:is_playing()) then
				print("index: " .. tostring(index) .. ", elements: " .. tostring(#elements));

				-- Early exit if the player has pressed escape or the ambush cutscene has stopped executing.
				if index == #elements then
					-- If we've reached the end then clean up.
					print("End: Finished Cutscene");
					gb:remove_listener("speech_update");
					gb:message_on_time_offset("generated_custscene_ended", 2000, true);
					subtitles:clear();
					
				else
				-- If we don't have an sfx or it's not playing iterate and play the new one.	
					print("Playing new VO audio");
					index = index + 1;	
					current_sound = new_sfx(elements[index][1]);
					current_subtitle = elements[index][2];
					
					--Subtitles
					subtitles:set_alignment("bottom_centre");
					subtitles:begin("bottom_centre");		
					subtitles:set_text(current_subtitle);
					
					--VO -- This doesn't work
					current_sound:playVO(player_commander.unit);
				end	
			end
			
			gb:message_on_time_offset("speech_update", 500, true);
		end
	end,
	true
);
