



--------------------------------------------------------------
----------------------- Missions ---------------------
--------------------------------------------------------------

-- Revenge
prologue_mission_revenge = mission_manager:new(prologue_player_faction, "wh3_prologue_mission_revenge");
prologue_mission_revenge:add_new_objective("SCRIPTED");
prologue_mission_revenge:add_condition("override_text mission_text_text_wh3_prologue_mission_revenge");
prologue_mission_revenge:add_condition("script_key mission_prologue_revenge");
prologue_mission_revenge:add_payload("add_ancillary_to_faction_pool{ancillary_key wh3_main_anc_talisman_star_iron_ring;}");

-- Rescue
prologue_mission_rescue = mission_manager:new(prologue_player_faction, "wh3_prologue_mission_rescue");
prologue_mission_rescue:add_new_objective("SCRIPTED");
prologue_mission_rescue:add_condition("override_text mission_text_text_wh3_prologue_mission_rescue");
prologue_mission_rescue:add_condition("script_key mission_prologue_rescue");
prologue_mission_rescue:add_payload("add_ancillary_to_faction_pool{ancillary_key wh3_prologue_anc_follower_cartographer;}");

-- Respite
prologue_mission_respite = mission_manager:new(prologue_player_faction, "wh3_prologue_mission_respite");
prologue_mission_respite:add_new_objective("SCRIPTED");
prologue_mission_respite:add_condition("override_text mission_text_text_wh3_prologue_mission_respite");
prologue_mission_respite:add_condition("script_key mission_prologue_respite");
prologue_mission_respite:add_payload("money 1000");

-- Reclaim
prologue_mission_reclaim = mission_manager:new(prologue_player_faction, "wh3_prologue_mission_reclaim");
prologue_mission_reclaim:add_new_objective("SCRIPTED");
prologue_mission_reclaim:add_condition("override_text mission_text_text_wh3_prologue_mission_reclaim");
prologue_mission_reclaim:add_condition("script_key mission_prologue_reclaim");
prologue_mission_reclaim:add_payload("add_ancillary_to_faction_pool{ancillary_key wh3_main_anc_armour_frost_shard_armour;}");

prologue_mission_capture_mansion_of_eyes = mission_manager:new(prologue_player_faction, "wh3_prologue_mission_capture_regions_mansion_of_eyes");
prologue_mission_capture_mansion_of_eyes:add_new_objective("SCRIPTED");
prologue_mission_capture_mansion_of_eyes:add_condition("override_text mission_text_text_wh3_prologue_mission_capture_regions_mansion_of_eyes");
prologue_mission_capture_mansion_of_eyes:add_condition("script_key mission_capture_regions_mansion_of_eyes");
prologue_mission_capture_mansion_of_eyes:add_payload("text_display dummy_wh3_prologue_mission_capture_regions_mansion_of_eyes");

prologue_mission_ice_maiden_actions = mission_manager:new(prologue_player_faction, "wh3_prologue_ice_maiden_actions");
prologue_mission_ice_maiden_actions:add_new_objective("SCRIPTED");
prologue_mission_ice_maiden_actions:add_condition("override_text mission_text_text_wh3_prologue_ice_maiden_actions");
prologue_mission_ice_maiden_actions:add_condition("script_key mission_ice_maiden_actions");
prologue_mission_ice_maiden_actions:add_payload("text_display dummy_wh3_prologue_ice_maiden_actions");

prologue_mission_patriarch_actions = mission_manager:new(prologue_player_faction, "wh3_prologue_mission_patriarch_actions");
prologue_mission_patriarch_actions:add_new_objective("SCRIPTED");
prologue_mission_patriarch_actions:add_condition("override_text mission_text_text_wh3_prologue_mission_patriarch_actions");
prologue_mission_patriarch_actions:add_condition("script_key mission_patriarch_actions");
prologue_mission_patriarch_actions:add_payload("add_ancillary_to_faction_pool{ancillary_key wh3_main_anc_enchanted_item_saint_annushkas_finger_bone;}");

prologue_mission_building_level = mission_manager:new(prologue_player_faction, "wh3_prologue_mission_building_level");
prologue_mission_building_level:add_new_objective("SCRIPTED");
prologue_mission_building_level:add_condition("override_text mission_text_text_wh3_prologue_mission_building_level");
prologue_mission_building_level:add_condition("script_key prologue_mission_building_level");
prologue_mission_building_level:add_payload("text_display dummy_wh3_prologue_mission_building_level");

prologue_mission_make_alliance = mission_manager:new(prologue_player_faction, "wh3_prologue_mission_make_alliance");
prologue_mission_make_alliance:add_new_objective("SCRIPTED");
prologue_mission_make_alliance:add_condition("override_text mission_text_text_wh3_prologue_mission_make_alliance");
prologue_mission_make_alliance:add_condition("script_key prologue_mission_make_alliance");
prologue_mission_make_alliance:add_payload("text_display dummy_wh3_prologue_mission_make_alliance");

prologue_mission_raid_region = mission_manager:new(prologue_player_faction, "wh3_prologue_raid_region");
prologue_mission_raid_region:add_new_objective("SCRIPTED");
prologue_mission_raid_region:add_condition("override_text mission_text_text_wh3_prologue_raid_region");
prologue_mission_raid_region:add_condition("script_key prologue_raid_region");
prologue_mission_raid_region:add_payload("money 3000");

--------------------------------------------------------------
----------------------- Dilemmas -----------------------------
--------------------------------------------------------------

-- STORY PANEL 1 - TROUBLE AT THE BEACON
function PrologueTroubleDilemma()

	skip_all_scripted_tours();

	core:add_listener(
		"DilemmaIssued_Storypanel",
		"DilemmaIssuedEvent",
		true,
		function()
			PrologueRemoveObjective();
			
			--Yuri text: We searched for our kin fleeing south. We found them travelling the hidden trails to avoid open ground. Some had left Dervingard. They said the stronghold had fallen. That its commander, the Boyar Slavin Kurnz had abandoned his post. Yet others fled from a smaller fort they called the Beacon. They spoke of a tribal chief that thirsted for bloodshed, Skollden, the Wolf of Dervingard.
			trigger_campaign_vo_prologue("Play_wh3_prologue_narrative_story_panel_01_1", "", 2.0);

			--Metric check (step_number, step_name, skippable)
			cm:trigger_prologue_step_metrics_hit(21, "triggered_trouble_dilemma", false);
		end,
		false
	);

	start_dilemma("wh3_prologue_trouble_at_beacon", false)
	
	core:add_listener( 
		"DilemmaChoiceMadeEvent_Trouble",
		"DilemmaChoiceMadeEvent",
		true,
		function(context) 

			cm:toggle_dilemma_generation(true);

			-- This is disabled here and re-enabled when the player confirms their trait.
			cm:disable_saving_game(true)
			cm:disable_end_turn(true)

			cm:stop_campaign_advisor_vo();

			local option = 1;

			if  context:choice() == 0 then
				Give_Trait(_, "wh3_main_prologue_saviour", 1, _, true)
				--Metric check (step_number, step_name, skippable
				cm:trigger_prologue_step_metrics_hit(22, "trouble_dilemma_choice_save", true);
			else
				option = 2;
				Give_Trait(_, "wh3_main_prologue_vengeful", 1, _, true)
				--Metric check (step_number, step_name, skippable)
				cm:trigger_prologue_step_metrics_hit(23, "trouble_dilemma_choice_punish", true);
			end

			core:add_listener(
				"prologue_after_dilemma_choice",
				"PanelOpenedCampaign",
				function(context) return context.string == "events" end,
				function()
					core:add_listener(
						"prologue_trait_gained",
						"PanelClosedCampaign",
						function(context) return context.string == "events" end,
						function()
							cm:disable_end_turn(false)
							prologue_load_check = "after_trouble_dilemma";
							if option == 1 then
								prologue_advice_trouble_at_beacon_1_001();
								prologue_story_choice = 1;
							else
								prologue_advice_trouble_at_beacon_2_001();
								prologue_story_choice = 2;
							end
							cm:contextual_vo_enabled(true);
						end,
						false
					);
				end,
				false
			);
			
		end,
		false
	);
end

-- STORY PANEL 3 - THE JOURNAL
function PrologueJournalDilemma()
	
	cm:toggle_dilemma_generation(false);
	
	core:add_listener(
		"DilemmaIssued_Storypanel",
		"DilemmaIssuedEvent",
		true,
		function()
			completely_lock_input(false)
			--Yuri text: Zorya, the Frost Maiden recounted the fall of Dervingard.
			--The commander, Slavin Kurnz, fell into madness. Tainted by the Dark Gods, his iron will tempered into a endless want for power.
			--The Boyar abandoned the stronghold. Taking all provisions, he left for the far reaches of the Chaos wastes. Any who opposed were hung from the walls.
			--Those that remained suffered at the hands of the savage northmen.
			--I found Kurnz's journal, hidden in his quarters. His words evidence of heresy. Ursun's judgement will be swift. If I find him, I will kill him.
			trigger_campaign_vo_prologue("Play_wh3_prologue_narrative_story_panel_03_1", "", 2.0);

			--Metric check (step_number, step_name, skippable)
			cm:trigger_prologue_step_metrics_hit(74, "triggered_journal_dilemma", false);
		end,
		false
	);

	start_dilemma("wh3_prologue_journal", false)

	core:add_listener( 
		"DilemmaChoiceMadeEvent_Journal",
		"DilemmaChoiceMadeEvent",
		true,
		function(context) 

			cm:stop_campaign_advisor_vo();

			if  context:choice() == 0 then
				Give_Trait(_, "wh3_main_prologue_devious", 1, _, true)
				prologue_advice_journal_option_1_001();
				--Metric check (step_number, step_name, skippable)
				cm:trigger_prologue_step_metrics_hit(75, "journal_dilemma_choice_secret", true);
			else
				Give_Trait(_, "wh3_main_prologue_honest", 1, _, true)
				prologue_advice_journal_option_2_001()
				--Metric check (step_number, step_name, skippable)
				cm:trigger_prologue_step_metrics_hit(76, "journal_dilemma_choice_tell_gerik", true);
			end

			cm:toggle_dilemma_generation(true);
		end,
		false
	);
end


-- STORY PANEL 4 - CHANGER OF THE WAYS
function PrologueTzeentchDilemma()

	core:add_listener(
		"DilemmaIssued_Storypanel",
		"DilemmaIssuedEvent",
		true,
		function()		
			--Yuri text: Ursun growls low in my ear. He tells me knowledge forbidden by the Great Orthodoxy. I now know the names of the Dark Gods, and their daemonic servants. The land warps under the influence of Tzeentch, the Changer of the Ways, the Chaos God of magic and Architect of Fate. The Daemons that serve Tzeentch are spellcasters and creatures of arcane fire.
			trigger_campaign_vo_prologue("Play_wh3_prologue_narrative_story_panel_04_1", "", 2.0);
			--Metric check (step_number, step_name, skippable)
			cm:trigger_prologue_step_metrics_hit(80, "triggered_changer_of_the_ways_dilemma", false);
		end,
		false
	);

	start_dilemma("wh3_prologue_changer_of_the_ways", false)

	core:add_listener( 
		"DilemmaChoiceMadeEvent_Journal",
		"DilemmaChoiceMadeEvent",
		true,
		function(context) 
			cm:stop_campaign_advisor_vo();

			if context:choice() == 0 then
				PrologueUnlockRoR("wh3_main_pro_ksl_mon_snow_leopard_ror_0_recruitable")
				RecruitmentReminder()
				--Metric check (step_number, step_name, skippable)
				cm:trigger_prologue_step_metrics_hit(81, "changer_of_ways_dilemma_choice_snow_leopard", true);
			else
				PrologueUnlockRoR("wh3_main_pro_ksl_veh_light_war_sled_ror_0_recruitable")
				RecruitmentReminder()
				--Metric check (step_number, step_name, skippable)
				cm:trigger_prologue_step_metrics_hit(82, "changer_of_ways_dilemma_choice_war_sled", true);
			end

			cm:toggle_dilemma_generation(true);
		end,
		false
	);
end

-- STORY PANEL 6 - THE RUINS
function PrologueRuinsDilemma()

	core:add_listener(
		"DilemmaIssued_Storypanel",
		"DilemmaIssuedEvent",
		true,
		function()
			-- Yuri text: We came upon ruins. A village of hide tents dominated by an eagle totem. They belonged to northmen, enemies of Kislev, who worshipped Tzeentch. On the ground, smeared in blood, was the emblem of the traitor Slavin Kurnz. His army had slaughtered the tribe, and left the bodies dangling from the totem. No mercy was given, but I felt no pity. In these unforgiving lands, would the northmen have have treated us any different?
			trigger_campaign_vo_prologue("Play_wh3_prologue_narrative_story_panel_06_1", "", 2.0);
			--Metric check (step_number, step_name, skippable)
			cm:trigger_prologue_step_metrics_hit(88, "triggered_ruins_dilemma", false);
		end,
		false
	);

	start_dilemma("wh3_prologue_the_ruins", false)

	core:add_listener( 
		"DilemmaChoiceMadeEvent_Ruins",
		"DilemmaChoiceMadeEvent",
		true,
		function(context) 
			cm:stop_campaign_advisor_vo();
			prologue_advice_ruins_dilemma_001();
			cm:toggle_dilemma_generation(true);
			if context:choice() ~= 0 then
				--Metric check (step_number, step_name, skippable)
				cm:trigger_prologue_step_metrics_hit(89, "ruins_dilemma_choice_bury", true);
			else
				--Metric check (step_number, step_name, skippable)
				cm:trigger_prologue_step_metrics_hit(90, "ruins_dilemma_choice_ransack", true);
			end
		end,
		false
	);
end


-- STORY PANEL 7 - REVEALED IN THE MAZE
function PrologueMazeDilemma()

	core:add_listener(
		"DilemmaIssued_Storypanel",
		"DilemmaIssuedEvent",
		true,
		function()
			--Yuri text: How long did I wander? Hours? Days? Yet finally, I reached the heart of the maze. Dark runes appeared before my eyes, but the journal revealed their secrets. A way for mortals to span the Screaming Chasm and reach the Howling Citadel.
			--I must go to the land of the Blood God. Inscribed upon His Brazen Altar, the words to summon the bridge-maker, the one who thirsts for more than blood.
			--When I emerged from the maze my army was waiting, but they did not cheer. Just cold, hard stares and the stink of ingratitude.
			trigger_campaign_vo_prologue("Play_wh3_prologue_narrative_story_panel_07_1", "", 2.0);
			--Metric check (step_number, step_name, skippable)
			cm:trigger_prologue_step_metrics_hit(94, "triggered_revealed_in_maze_dilemma", false);
		end,
		false
	);

	start_dilemma("wh3_prologue_revealed_the_maze", false)

	core:add_listener( 
		"DilemmaChoiceMadeEvent_Maze",
		"DilemmaChoiceMadeEvent",
		true,
		function(context) 
			cm:stop_campaign_advisor_vo();

			if context:choice() ~= 0 then
				Give_Trait(_, "wh3_main_prologue_egotist", 1, _, true)
				--Metric check (step_number, step_name, skippable)
				cm:trigger_prologue_step_metrics_hit(95, "revealed_in_maze_dilemma_rally", true);
			else
				--Metric check (step_number, step_name, skippable)
				cm:trigger_prologue_step_metrics_hit(96, "revealed_in_maze_dilemma_ignore", true);
			end

			core:add_listener(
				"Prologue_MazeDilemma_reward",
				"PanelClosedCampaign",
				function(context) return context.string == "events" end,
				function()
					disable_key_battle_events(false)
					
					cm:disable_saving_game(true)

					prologue_advice_after_maze_battle_001();
				end,
				false
			);

			cm:toggle_dilemma_generation(true);
		end,
		false
	);
end


-- STORY PANEL 10 - BEYOND THE BRAZEN ALTAR
function PrologueBeyondDilemma()	
	core:remove_listener("MissionSucceeded_Prologue_Reveal")
	
	cm:toggle_dilemma_generation(false)
	
	core:add_listener(
		"DilemmaIssued_Storypanel",
		"DilemmaIssuedEvent",
		true,
		function()
			--Yuri text: I approached the Brazen Altar and quenched my sword in the blood. As I withdrew it, dark runes glowed upon the blade. It was a name. One to speak at the Screaming Chasm. One to summon the bridge-maker. A toll would be required, my faith tested. Whatever trial waited; I was ready.
			trigger_campaign_vo_prologue("Play_wh3_prologue_narrative_story_panel_10_1", "", 2.0);
			--Metric check (step_number, step_name, skippable)
			cm:trigger_prologue_step_metrics_hit(103, "triggered_post_altar_dilemma", false);
		end,
		false
	);

	start_dilemma("wh3_prologue_post_altar", false)

	core:add_listener( 
		"DilemmaChoiceMadeEvent_Beyond",
		"DilemmaChoiceMadeEvent",
		true,
		function(context) 
			cm:stop_campaign_advisor_vo();

			if context:choice() == 0 then
				Give_Trait(_, "wh3_main_prologue_warlord", 1, _, true)
				--Metric check (step_number, step_name, skippable)
				cm:trigger_prologue_step_metrics_hit(104, "post_altar_dilemma_choice_legend", true);
			else
				Give_Trait(_, "wh3_main_prologue_chosen", 1, _, true)
				--Metric check (step_number, step_name, skippable)
				cm:trigger_prologue_step_metrics_hit(105, "post_altar_dilemma_choice_god", true);
			end
			
			disable_key_battle_events(false)
			
			prologue_advice_after_brazen_altar_battle_001();
			cm:toggle_dilemma_generation(true);
		end,
		false
	);

end


-- STORY PANEL 2 - THE SWORD
function PrologueSwordDilemma()

	cm:whitelist_event_feed_event_type("faction_event_character_incidentevent_feed_target_incident_faction");
	cm:whitelist_event_feed_event_type("faction_event_incidentevent_feed_target_incident_faction");
	cm:whitelist_event_feed_event_type("faction_event_region_incidentevent_feed_target_incident_faction"); 

	cm:toggle_dilemma_generation(false)

	core:add_listener(
		"DilemmaIssued_Storypanel",
		"DilemmaIssuedEvent",
		true,
		function()
			--Yuri text: The stronghold we had searched for, longed for, was ours. But I could not rejoice, I felt only the loss of those who had given their lives. At least the Wolf was slain. 
			--Yet, even in death, his hand reached towards his tainted sword, Wolfbane. Ursun compelled me to take it. A man of faith can withstand its evil and harness its power.
			trigger_campaign_vo_prologue("Play_wh3_prologue_narrative_story_panel_02_1", "", 2.0);

			--Metric check (step_number, step_name, skippable)
			cm:trigger_prologue_step_metrics_hit(65, "triggered_sword_dilemma", false);
		end,
		false
	);

	start_dilemma("wh3_prologue_take_sword", false)
			
	core:add_listener( 
		"DilemmaChoiceMadeEvent_Sword",
		"DilemmaChoiceMadeEvent",
		true,
		function(context) 		
			cm:toggle_dilemma_generation(true)
			cm:disable_saving_game(true)

			cm:stop_campaign_advisor_vo();

			if context:choice() == 0 then
				Give_Trait(_, "wh3_main_prologue_saviour", 1, _, true)
				--Metric check (step_number, step_name, skippable)
				cm:trigger_prologue_step_metrics_hit(66, "sword_dilemma_choice_strong", true);
			else
				Give_Trait(_, "wh3_main_prologue_vengeful", 1, _, true)
				--Metric check (step_number, step_name, skippable)
				cm:trigger_prologue_step_metrics_hit(67, "sword_dilemma_choice_sharp", true);
			end

			--award the sword as a magic item
			local yuri_army_list = cm:model():world():faction_by_key(prologue_player_faction):military_force_list();
			for i = 0, yuri_army_list:num_items() - 1 do
				if yuri_army_list:item_at(i):upkeep() > 0 then
					local general = yuri_army_list:item_at(i):general_character();
					cm:toggle_incident_generation(false);
					cm:force_add_ancillary(general, "wh3_prologue_anc_weapon_traitor_sword", true, true);
					prologue_check_progression["equipped_sword"] = true
					cm:toggle_incident_generation(true);
				end
			end

			core:add_listener(
				"PanelClosedCampaignAfterSwordEvent",
				"PanelClosedCampaign",
				function(context) return context.string == "events" end,
				function() 
					prologue_advice_at_dervingard_sword_001();
				end,
				false
			)

		end,
		false
	);
end


-- STORY PANEL 5 - TRIALS OF THE WASTES
function PrologueTrialsDilemma()

	prologue_load_check = "trials"

	cm:toggle_dilemma_generation(false)

	core:add_listener(
		"DilemmaIssued_Storypanel",
		"DilemmaIssuedEvent",
		true,
		function()
			--Yuri text: By campfire light, I read the journal to understand why Kurnz abandoned his duty? 
			--Before he left Dervingard, he made forays into the Chaos Wastes. He fought enemies and even gained the allegiance of  tribes. He called such feats "The Trials". They allowed him to navigate the hostile lands. 
			--If I am to survive here, I must perform these Trials. The journal tells of great rewards if I do.
			trigger_campaign_vo_prologue("Play_wh3_prologue_narrative_story_panel_05_1", "", 2.0);
			--Metric check (step_number, step_name, skippable)
			cm:trigger_prologue_step_metrics_hit(85, "triggerd_trials_dilemma", false);
		end,
		false
	);

	start_dilemma("wh3_prologue_trials", false)
			
	core:add_listener( 
		"DilemmaChoiceMadeEvent_Trials",
		"DilemmaChoiceMadeEvent",
		true,
		function(context) 
			cm:stop_campaign_advisor_vo();

			if context:choice() == 0 then
				cm:trigger_mission(prologue_player_faction, "wh3_prologue_mission_defeat_n_armies_of_faction_tze", true)
				--Metric check (step_number, step_name, skippable)
				cm:trigger_prologue_step_metrics_hit(86, "trials_dilemma_choice_subjugator", true);
			else
				prologue_mission_capture_mansion_of_eyes:trigger();
				prologue_check_progression["triggered_mansion_of_eyes_mission"] = true
				--Metric check (step_number, step_name, skippable)
				cm:trigger_prologue_step_metrics_hit(87, "trials_dilemma_choice_conqueror", true);
			end
			
			prologue_load_check = "";
			cm:toggle_dilemma_generation(true)
			core:remove_listener("FactionTurnStartTrialsDilemma")
			uim:override("end_turn"):set_allowed(true);

			core:add_listener(
				"PanelClosedCampaignAfterTrialMission",
				"PanelClosedCampaign",
				function(context) return context.string == "events" end,
				function() 
					cm:contextual_vo_enabled(true);
				end,
				false
			)

			cm:cai_enable_movement_for_faction("wh3_prologue_the_sightless");
			cm:cai_enable_movement_for_faction("wh3_prologue_apostles_of_change");

		end,
		false
	);
end



-- STORY PANEL 8 - THEY BRING TRIBUTE
function PrologueTributeDilemma()

	cm:toggle_dilemma_generation(false)
	
	core:add_listener(
		"DilemmaIssued_Storypanel",
		"DilemmaIssuedEvent",
		true,
		function()
			--Yuri text: Word has spread. The tribes hear of my exploits. A Kislevite who subjugates Daemons and emerges from Tzeentch's labyrinth.
			--Where before they would have ridden out to crush us, now they send an envoy and some piffling tribute to try and buy my allegiance. Gerik urges caution, as usual, but I could turn this to my advantage. Dominate these lands, not just with war, but with words. 
			--Through such base diplomacy, I can further my quest to find Ursun. All I need do, is accept their gift.
			trigger_campaign_vo_prologue("Play_wh3_prologue_narrative_story_panel_08_1", "", 2.0);
			--Metric check (step_number, step_name, skippable)
			cm:trigger_prologue_step_metrics_hit(97, "triggered_tribute_dilemma", false);
		end,
		false
	);

	start_dilemma("wh3_prologue_tribute", false)

	BlockEventSaveEnable(true)

	core:add_listener( 
		"DilemmaChoiceMadeEventTribute",
		"DilemmaChoiceMadeEvent",
		true,
		function(context) 
			cm:toggle_dilemma_generation(true)

			cm:stop_campaign_advisor_vo();

			if  context:choice() == 0 then
				cm:add_ancillary_to_faction(prologue_player_faction_interface, "wh_main_anc_enchanted_item_healing_potion", false)
				--Metric check (step_number, step_name, skippable)
				cm:trigger_prologue_step_metrics_hit(98, "tribute_dilemma_choice_accept", true);
			else
				cm:add_ancillary_to_faction(prologue_player_faction_interface, "wh_main_anc_enchanted_item_potion_of_strength", false)
				cm:apply_effect_bundle("wh3_prologue_diplomatic_bonus_tribes", prologue_player_faction, 10)
				--Metric check (step_number, step_name, skippable)
				cm:trigger_prologue_step_metrics_hit(99, "tribute_dilemma_choice_trade", true);
			end

			core:add_listener(
				"PanelClosedCampaign_EndtributeDilemma",
				"PanelClosedCampaign",
				function(context) return context.string == "events" end,
				function()
					core:add_listener(
						"PanelClosedCampaign_EndPotionEvent",
						"PanelClosedCampaign",
						function(context) return context.string == "events" end,
						function()

							-- Re-enable event saving.
							cm:callback(function() BlockEventSaveEnable(false) end, 1)

							local new_player = cm:model():shared_states_manager():get_state_as_bool_value("prologue_tutorial_on");
							if new_player then
								core:trigger_event("ScriptEventPrologueDiplomacy");
								prologue_tutorial_passed["diplomacy_with_button_hidden"] = true;
							else
								prologue_tutorial_passed["diplomacy_with_button_hidden"] = true;
								uim:override("diplomacy_with_button_hidden"):set_allowed(true);
								cm:enable_all_diplomacy(true);
								prologue_advice_unlock_diplomacy_001()

								cm:cai_enable_movement_for_faction("wh3_prologue_blood_keepers");
								cm:cai_enable_movement_for_faction("wh3_prologue_sarthoraels_watchers");
								cm:cai_enable_movement_for_faction("wh3_prologue_the_tahmaks");
								cm:cai_enable_movement_for_faction("wh3_prologue_the_kvelligs");
								cm:cai_enable_movement_for_faction("wh3_prologue_great_eagle_tribe");
								cm:cai_enable_movement_for_faction("wh3_prologue_tong");
							end	
						end,
						false
					);																		
				end,
				false
			);
		end,
		false
	)
end


-- STORY PANEL 9 - FEAR ME
function PrologueFearMeDilemma()

	cm:toggle_dilemma_generation(false)

	-- I added this here because it was never set to true anywhere. Do we want it here? -Joy
	--prologue_check_progression["triggered_fear_dilemma"] = true

	core:add_listener(
		"DilemmaIssued_Storypanel",
		"DilemmaIssuedEvent",
		true,
		function()
			cm:contextual_vo_enabled(false);
			--Yuri text: I tamed the tribes. The northmen bow to me. Fear me.
			--It should have been a time of triumph. Yet I heard my soldiers, sniping behind my back! 
			--I ordered Gerik to round up the seditious ones. They were  Ungols who came with me from Kislev, supposedly my most loyal. They stand before me, griping. Whining about returning to the Motherland. I let them go, but stripped of everything, armour, weapons, even their boots!
			--If they cast me in the role of Warlord, then I will play the part!
			trigger_campaign_vo_prologue("Play_wh3_prologue_narrative_story_panel_09_1", "", 2.0);
		end,
		false
	);

	start_dilemma("wh3_prologue_fear_me", false)

	core:remove_listener("MissionSucceeded_Prologue_Reveal")

	core:add_listener( 
		"DilemmaChoiceMadeEvent_Beyond",
		"DilemmaChoiceMadeEvent",
		true,
		function(context) 

			if  context:choice() == 0 then
				Give_Trait(_, "wh3_main_prologue_vengeful", 1, _, true)
			else
				Give_Trait(_, "wh3_main_prologue_saviour", 1, _, true)
			end

			cm:stop_campaign_advisor_vo();
			cm:toggle_dilemma_generation(true);
			uim:override("end_turn"):set_allowed(true);
			core:add_listener(
				"PanelClosedCampaign_EndTraitEvent",
				"PanelClosedCampaign",
				function(context) return context.string == "events" end,
				function()
					cm:contextual_vo_enabled(true);	
				end,
				false
			);
		end,
		false
	)
end

-- STORY PANEL 11 - DAEMONS PRICE 1
function PrologueDaemonDilemma()
	
	cm:toggle_dilemma_generation(false);
	
	core:add_listener(
		"DilemmaIssued_Storypanel",
		"DilemmaIssuedEvent",
		true,
		function()
			--YURI: I said its name. The skies rained with blood as a Greater Daemon of Khorne emerged from the Screaming Chasm, great wings carried it over the edge and the ground shook as the Bloodthirster landed beside me."
			trigger_campaign_vo_prologue("Play_wh3_prologue_narrative_story_panel_11_1", "", 2.0);

			cm:callback(function()
				local uic_button = find_uicomponent(core:get_ui_root(), "events", "incident_large", "background", "footer", "text_button");
	
				if uic_button then
					uic_button:SetVisible(false); 
					cm:callback(function() uic_button:SetVisible(true); end, 5);
				end
			end, 0.3);
		end,
		false
	);

	start_dilemma("wh3_prologue_daemons_price_1", false)

	core:add_listener( 
		"DilemmaChoiceMadeEvent_Daemon_1",
		"DilemmaChoiceMadeEvent",
		true,
		function(context) 

			cm:stop_campaign_advisor_vo();

			if  context:choice() == 0 then
				
				cm:add_scripted_composite_scene_to_logical_position("skull_bridge", "prologue_skull_bridge", 412, 480, 412, 481, false, true, false);

				cm:steal_user_input(true);

				PrologueDaemonTwoDilemma();
			end
		end,
		false
	);
end

-- STORY PANEL 12 - DAEMONS PRICE 2
function PrologueDaemonTwoDilemma()
	
	core:add_listener(
		"DilemmaIssued_Storypanel",
		"DilemmaIssuedEvent",
		true,
		function()
			cm:steal_user_input(false);
			--Yuri text: My brother’s lifeless body fell to the ground. The Bloodthirster roared as he threw Gerik’s screaming skull onto the bridge. I crossed the chasm, the daemon beside me. My army wavered, yet followed, fearing my wrath.
			trigger_campaign_vo_prologue("Play_wh3_prologue_narrative_story_panel_12_1", "", 2.0);
		end,
		false
	);

	start_dilemma("wh3_prologue_daemons_price_2", false)

	core:add_listener( 
		"DilemmaChoiceMadeEvent_Daemon_2",
		"DilemmaChoiceMadeEvent",
		true,
		function(context) 

			cm:stop_campaign_advisor_vo();

			if  context:choice() == 0 then

				cm:teleport_to(cm:char_lookup_str(cm:get_faction(prologue_player_faction):faction_leader():command_queue_index()), 413, 481);

				cm:disable_pathfinding_restriction(7);

				prologue_check_progression["killed_gerik"] = true;

				cm:add_character_actor_group_override(player, "wh3_main_vo_actor_Prologue_Yuri_4");

				local cutscene_intro = campaign_cutscene:new_from_cindyscene(
					"prologue_howling_citadel2",
					function() 
						cm:disable_saving_game(false)
						-- Re-enable character flags that were disabled for cutscenes.
						uim:override("campaign_flags"):set_allowed(true)

						cm:callback(function()
							cm:set_camera_position(271.026154, 388.708069, 17.940491, 0.0, 29.999998);
							cm:make_region_visible_in_shroud(prologue_player_faction, "wh3_prologue_region_temp_4");
							cm:contextual_vo_enabled(true);	
						end, 0.5)
					end,
					"citadel_reveal_01",
					0, 
					1
				);
					
				cutscene_intro:set_disable_settlement_labels(true);
				cutscene_intro:set_dismiss_advice_on_end(false);
				cutscene_intro:set_restore_shroud(true);
				cutscene_intro:set_skippable(true);
				cutscene_intro:set_disable_shroud(true);
						
				cutscene_intro:action(
					function()
						cm:trigger_2d_ui_sound("UI_CAM_PRO_Story_Stinger", 0);
						CampaignUI.ClearSelection();
						cm:replenish_action_points("faction:"..prologue_player_faction..",forename:1643960929", 1)
						cm:move_character(prologue_player_cqi, 408, 489, false, false);
					end,
					0
				);

				uim:override("campaign_flags"):set_allowed(false);

				cm:callback(function() cutscene_intro:start(); end, 0.2);
			end

			cm:toggle_dilemma_generation(true);
		end,
		false
	);
end

--------------------------------------------------------------
----------------------- FUNCTION -----------------------------
--------------------------------------------------------------

-- This only needs to happen once per campaign.
function first_load_story_panels()
	if not prologue_check_progression["first_load_story_panels"] then
		prologue_check_progression["first_load_story_panels"] = true
	end
end
first_load_story_panels()

	-- Functions for starting dilemmas
do

	local dialogue_finishing_timer = 0 -- Sets the timer for how long a dilemma should wait before triggering after VO/dialogue.
	local dialogue_finishing = false -- The script sets this value. Don't modify.
	
	function start_dilemma(name, incident)
		local disabled_saving = false

		local function start_dilemma_callback()
			stop_moving_all_player_characters()
			CampaignUI.ClearSelection()

			if incident then
				cm:trigger_incident(prologue_player_faction, name, true)
			else
				cm:trigger_dilemma(prologue_player_faction, name)
			end
		end
		
		-- Wait before dialogue is finished before starting dilemma
		if dialogue_in_progress or dialogue_finishing then
			if common.get_context_value("CcoCampaignRoot", "", "CanQuickSave") then
				cm:disable_saving_game(true)
				disabled_saving = true
			end

			cm:repeat_callback(
				function()
					if dialogue_in_progress == false and dialogue_finishing == false then
						if disabled_saving then cm:disable_saving_game(false) end
						start_dilemma_callback()
						cm:remove_callback("WaitForDialogueToFinish")
					end
				end,
				0.1,
				"WaitForDialogueToFinish"
			)
		else
			start_dilemma_callback()
		end
	end

	-- This is called after a dilemma is finished
	function set_end_of_dialogue_timer()
		dialogue_finishing = true
		cm:callback(function() dialogue_finishing = false end, dialogue_finishing_timer)
	end
end

-- Halts the movement of all the player's characters so they can't trigger other stuff while dilemmas start.
function stop_moving_all_player_characters()
	
	local character_list = cm:get_faction(cm:get_local_faction_name()):character_list()
	
	-- Cycle through characters and instruct any that are moving to move to their current position (halting them).
	for i = 0, character_list:num_items() - 1 do
		cm:is_character_moving(
			character_list:item_at(i):cqi(), 
			function()
				cm:move_character(character_list:item_at(i):cqi(), character_list:item_at(i):logical_position_x(), character_list:item_at(i):logical_position_y())
			end, 
			function() end
		)
	end
end