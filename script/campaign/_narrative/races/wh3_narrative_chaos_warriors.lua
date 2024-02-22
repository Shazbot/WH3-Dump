------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--
--	RACE-SPECIFIC NARRATIVE EVENT CHAINS
--
--	PURPOSE
--
--	This file defines chains of narrative events that are specific to a particular race. These are mostly 
--	tutorial missions related to race features like Khorne Skulls, Kislev Atamans, Cathay Compass etc. 
--	
--	The narrative loader function defined at the bottom of this file is added to the narrative system with a call
--	to narrative.add_loader_for_culture. The function will be called when the narrative system is started,
--	on or around the first tick, but only if there is a human-controlled faction in the campaign of the
--	relevant race.
--
--	LOADED
--	This file is currently loaded from wh3_narrative_shared_faction_data.lua, this may change in the future. It
--	is loaded when narrative.start() is called, as the faction data is loaded.
--	
--	AUTHORS
--	SV
--
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

out.narrative("* wh3_narrative_champions.lua loaded");

local shared_prepend_str = shared_narrative_event_prepend_str .. "_champions";


coc_narrative_missions = {}

coc_narrative_missions.sacrifice_souls = {
	wh3_dlc20_chs_azazel  	= {
		advice = "wh3_dlc20_azazel_cam_mission_chaos_gifts_001", 
		mission = "wh3_dlc20_camp_narrative_champions_sacrifice_souls_azazel", 
		objective_text = "wh3_dlc20_camp_narrative_mission_description_champions_sacrifice_souls_azazel", 
		reward = {payload.pooled_resource_mission_payload("wh3_dlc20_chs_souls", "wh3_dlc20_souls_other", 500)}, 
		pooled_resource = "wh3_dlc20_chs_souls_spent_sla", 
	},
	wh3_dlc20_chs_festus 	= {
		advice = "wh3_dlc20_festus_cam_mission_chaos_gifts_001", 
		mission = "wh3_dlc20_camp_narrative_champions_sacrifice_souls_festus", 
		objective_text = "wh3_dlc20_camp_narrative_mission_description_champions_sacrifice_souls_festus", 
		reward = {payload.pooled_resource_mission_payload("wh3_dlc20_chs_souls", "wh3_dlc20_souls_other", 500)}, 
		pooled_resource = "wh3_dlc20_chs_souls_spent_nur",
	},
	wh3_dlc20_chs_valkia 	= {
		advice = "wh3_dlc20_valkia_cam_mission_chaos_gifts_001",  
		mission = "wh3_dlc20_camp_narrative_champions_sacrifice_souls_valkia", 
		objective_text = "wh3_dlc20_camp_narrative_mission_description_champions_sacrifice_souls_valkia", 
		reward = {payload.pooled_resource_mission_payload("wh3_dlc20_chs_souls", "wh3_dlc20_souls_other", 500)}, 
		pooled_resource = "wh3_dlc20_chs_souls_spent_kho", 
	},
	wh3_dlc20_chs_vilitch 	= {
		advice = "wh3_dlc20_vilitch_cam_mission_chaos_gifts_001", 
		mission = "wh3_dlc20_camp_narrative_champions_sacrifice_souls_vilitch", 
		objective_text = "wh3_dlc20_camp_narrative_mission_description_champions_sacrifice_souls_vilitch", 
		reward = {payload.pooled_resource_mission_payload("wh3_dlc20_chs_souls", "wh3_dlc20_souls_other", 500)}, 
		pooled_resource = "wh3_dlc20_chs_souls_spent_tze", 
	}, 
}

coc_narrative_missions.gain_chaos_gift_slot = {
	wh3_dlc20_chs_azazel  	= {
		advice = "wh3_dlc20_azazel_cam_mission_chaos_gifts_slots_001", 
		mission = "wh3_dlc20_camp_narrative_champions_gain_chaos_gift_slot_azazel", 
		objective_text = "wh3_dlc20_camp_narrative_mission_description_champions_gain_chaos_gift_slot_azazel", 
		reward = {payload.pooled_resource_mission_payload("wh3_dlc20_chs_souls", "wh3_dlc20_souls_other", 1000)},
		technologies = {
			["wh3_dlc20_chs_sla_azazel_gift_slot_1"] = true, 
			["wh3_dlc20_chs_sla_azazel_gift_slot_2"] = true, 
			["wh3_dlc20_chs_und_shared_gift_slot_1"] = true, 
			["wh3_dlc20_chs_und_shared_gift_slot_2"] = true
		}
	},
	wh3_dlc20_chs_festus 	= {
		advice = "wh3_dlc20_festus_cam_mission_chaos_gifts_slots_001", 
		mission = "wh3_dlc20_camp_narrative_champions_gain_chaos_gift_slot_festus", 
		objective_text = "wh3_dlc20_camp_narrative_mission_description_champions_gain_chaos_gift_slot_festus", 
		reward = {payload.pooled_resource_mission_payload("wh3_dlc20_chs_souls", "wh3_dlc20_souls_other", 1000)}, 
		technologies = {
			["wh3_dlc20_chs_nur_festus_gift_slot_1"] = true, 
			["wh3_dlc20_chs_nur_festus_gift_slot_2"] = true, 
			["wh3_dlc20_chs_und_shared_gift_slot_1"] = true, 
			["wh3_dlc20_chs_und_shared_gift_slot_2"] = true
		}
	},
	wh3_dlc20_chs_valkia 	= {
		advice = "wh3_dlc20_valkia_cam_mission_chaos_gifts_slots_001",
		mission = "wh3_dlc20_camp_narrative_champions_gain_chaos_gift_slot_valkia", 
		objective_text = "wh3_dlc20_camp_narrative_mission_description_champions_gain_chaos_gift_slot_valkia", 
		reward = {payload.pooled_resource_mission_payload("wh3_dlc20_chs_souls", "wh3_dlc20_souls_other", 1000)},
		technologies = {
			["wh3_dlc20_chs_kho_valkia_gift_slot_1"] = true, 
			["wh3_dlc20_chs_kho_valkia_gift_slot_2"] = true, 
			["wh3_dlc20_chs_und_shared_gift_slot_1"] = true, 
			["wh3_dlc20_chs_und_shared_gift_slot_2"] = true
		}
	},
	wh3_dlc20_chs_vilitch 	= {
		advice = "wh3_dlc20_vilitch_cam_mission_chaos_gifts_slots_001",
		mission = "wh3_dlc20_camp_narrative_champions_gain_chaos_gift_slot_vilitch", 
		objective_text = "wh3_dlc20_camp_narrative_mission_description_champions_gain_chaos_gift_slot_vilitch", 
		reward = {payload.pooled_resource_mission_payload("wh3_dlc20_chs_souls", "wh3_dlc20_souls_other", 1000)},  
		technologies = {
			["wh3_dlc20_chs_tze_vilitch_gift_slot_1"] = true, 
			["wh3_dlc20_chs_tze_vilitch_gift_slot_2"] = true, 
			["wh3_dlc20_chs_und_shared_gift_slot_1"] = true, 
			["wh3_dlc20_chs_und_shared_gift_slot_2"] = true
		}
	}, 
}

coc_narrative_missions.mark_units = {
	wh3_dlc20_chs_azazel  	= {
		advice = "wh3_dlc20_azazel_cam_mission_warbands_001", 
		mission = "wh3_dlc20_camp_narrative_champions_mark_units_azazel", 
		objective_text = "wh3_dlc20_camp_narrative_mission_description_champions_mark_units_azazel", 
		reward = {payload.effect_bundle_mission_payload("wh3_dlc20_pre_battle_bribery_cost_reduction", 5), payload.money_direct(2000)}, 
		mark_key = "sla",  
		num_marked_units = 0, 
	},
	wh3_dlc20_chs_festus 	= {
		advice = "wh3_dlc20_festus_cam_mission_warbands_001", 
		mission = "wh3_dlc20_camp_narrative_champions_mark_units_festus", 
		objective_text = "wh3_dlc20_camp_narrative_mission_description_champions_mark_units_festus", 
		reward = {payload.effect_bundle_mission_payload("wh2_main_effect_army_movement_up", 5), payload.pooled_resource_mission_payload("wh3_main_nur_infections", "events", 50), payload.money_direct(2000)}, 
		mark_key = "nur",  
		num_marked_units = 0, 
	},
	wh3_dlc20_chs_valkia 	= {
		advice = "wh3_dlc20_valkia_cam_mission_warbands_001",
		mission = "wh3_dlc20_camp_narrative_champions_mark_units_valkia", 
		objective_text = "wh3_dlc20_camp_narrative_mission_description_champions_mark_units_valkia", 
		reward = {payload.effect_bundle_mission_payload("wh2_main_effect_army_movement_up", 5), payload.money_direct(2000)}, 
		mark_key = "kho",   
		num_marked_units = 0, 
	},
	wh3_dlc20_chs_vilitch 	= {
		advice = "wh3_dlc20_vilitch_cam_mission_warbands_001",
		mission = "wh3_dlc20_camp_narrative_champions_mark_units_vilitch", 
		objective_text = "wh3_dlc20_camp_narrative_mission_description_champions_mark_units_vilitch", 
		reward = {payload.effect_bundle_mission_payload("wh2_main_effect_army_movement_up", 5), payload.money_direct(2000)}, 
		mark_key = "tze",    
		num_marked_units = 0,    
	}, 
}

coc_narrative_missions.upgrade_units = {
	wh3_dlc20_chs_azazel  	= {
		advice = nil,
		mission = "wh3_dlc20_camp_narrative_champions_upgrade_units_azazel", 
		objective_text = "wh3_dlc20_camp_narrative_mission_description_champions_upgrade_units_azazel", 
		reward = {payload.pooled_resource_mission_payload("wh3_dlc20_chs_souls", "wh3_dlc20_souls_other", 500), payload.money_direct(2000)},   
		num_upgraded_units = 0, 
	},
	wh3_dlc20_chs_festus 	= {
		advice = nil,
		mission = "wh3_dlc20_camp_narrative_champions_upgrade_units_festus", 
		objective_text = "wh3_dlc20_camp_narrative_mission_description_champions_upgrade_units_festus", 
		reward = {payload.pooled_resource_mission_payload("wh3_dlc20_chs_souls", "wh3_dlc20_souls_other", 500), payload.pooled_resource_mission_payload("wh3_main_nur_infections", "events", 100), payload.money_direct(2000)},   
		num_upgraded_units = 0, 
	},
	wh3_dlc20_chs_valkia 	= {
		advice = nil,
		mission = "wh3_dlc20_camp_narrative_champions_upgrade_units_valkia", 
		objective_text = "wh3_dlc20_camp_narrative_mission_description_champions_upgrade_units_valkia", 
		reward = {payload.pooled_resource_mission_payload("wh3_dlc20_chs_souls", "wh3_dlc20_souls_other", 500), payload.money_direct(2000)}, 
		num_upgraded_units = 0, 
	},
	wh3_dlc20_chs_vilitch 	= {
		advice = nil,
		mission = "wh3_dlc20_camp_narrative_champions_upgrade_units_vilitch", 
		objective_text = "wh3_dlc20_camp_narrative_mission_description_champions_upgrade_units_vilitch", 
		reward = {payload.pooled_resource_mission_payload("wh3_dlc20_chs_souls", "wh3_dlc20_souls_other", 500), payload.money_direct(2000)}, 
		num_upgraded_units = 0, 
	}, 
}

coc_narrative_missions.increase_dark_authority = {
	wh3_dlc20_chs_azazel  	= {
		advice = nil, 
		mission = "wh3_dlc20_camp_narrative_champions_increase_dark_authority_azazel", 
		objective_text = "wh3_dlc20_camp_narrative_mission_description_champions_increase_dark_authority_azazel", 
		reward = {payload.mercenary_mission_payload("wh3_main_sla_inf_daemonette_0", 1), payload.money_direct(2000)}, 
		pooled_resource = "wh3_dlc20_chs_authority_slaanesh", 
	},
	wh3_dlc20_chs_festus 	= {
		advice = nil, 
		mission = "wh3_dlc20_camp_narrative_champions_increase_dark_authority_festus", 
		objective_text = "wh3_dlc20_camp_narrative_mission_description_champions_increase_dark_authority_festus", 
		reward = {payload.mercenary_mission_payload("wh3_main_nur_inf_plaguebearers_0", 1), payload.money_direct(2000)}, 
		pooled_resource = "wh3_dlc20_chs_authority_nurgle", 
	},
	wh3_dlc20_chs_valkia 	= {
		advice = nil, 
		mission = "wh3_dlc20_camp_narrative_champions_increase_dark_authority_valkia", 
		objective_text = "wh3_dlc20_camp_narrative_mission_description_champions_increase_dark_authority_valkia", 
		reward = {payload.mercenary_mission_payload("wh3_main_kho_inf_bloodletters_0", 1), payload.money_direct(2000)},  
		pooled_resource = "wh3_dlc20_chs_authority_khorne", 
	},
	wh3_dlc20_chs_vilitch 	= {
		advice = nil, 
		mission = "wh3_dlc20_camp_narrative_champions_increase_dark_authority_vilitch", 
		objective_text = "wh3_dlc20_camp_narrative_mission_description_champions_increase_dark_authority_vilitch", 
		reward = {payload.mercenary_mission_payload("wh3_main_tze_inf_pink_horrors_0", 1), payload.money_direct(2000)}, 
		pooled_resource = "wh3_dlc20_chs_authority_tzeentch",  
	}, 
}

coc_narrative_missions.path_to_glory = {
	wh3_dlc20_chs_azazel  	= {
		advice = "wh3_dlc20_azazel_cam_mission_glory_001", 
		mission = "wh3_dlc20_camp_narrative_champions_path_to_glory_azazel", 
		objective_text = "wh3_dlc20_camp_narrative_mission_description_champions_path_to_glory_azazel", 
		reward = {payload.mercenary_mission_payload("wh3_main_sla_mon_fiends_of_slaanesh_0", 1), payload.money_direct(2000)}, 
		initiatives = {
			["wh3_dlc20_character_initiative_devote_lord_to_slaanesh"] = true,
			["wh3_dlc20_character_initiative_devote_sorceror_to_slaanesh_shadows"] = true, 
			["wh3_dlc20_character_initiative_devote_sorceror_to_slaanesh_slaanesh"] = true
		} 
	},
	wh3_dlc20_chs_festus 	= {
		advice = "wh3_dlc20_festus_cam_mission_glory_001", 
		mission = "wh3_dlc20_camp_narrative_champions_path_to_glory_festus", 
		objective_text = "wh3_dlc20_camp_narrative_mission_description_champions_path_to_glory_festus", 
		reward = {payload.mercenary_mission_payload("wh3_main_nur_cav_plague_drones_0", 1), payload.money_direct(2000)}, 
		initiatives = {
			["wh3_dlc20_character_initiative_devote_exalted_hero_to_nurgle"] = true,
			["wh3_dlc20_character_initiative_devote_sorceror_lord_to_nurgle_death"] = true, 
			["wh3_dlc20_character_initiative_devote_sorceror_lord_to_nurgle_nurgle"] = true
		} 					
	},
	wh3_dlc20_chs_valkia 	= {
		advice = "wh3_dlc20_valkia_cam_mission_glory_001", 
		mission = "wh3_dlc20_camp_narrative_champions_path_to_glory_valkia", 
		objective_text = "wh3_dlc20_camp_narrative_mission_description_champions_path_to_glory_valkia", 
		reward = {payload.mercenary_mission_payload("wh3_main_kho_veh_skullcannon_0", 1), payload.money_direct(2000)}, 
		initiatives = {
			["wh3_dlc20_character_initiative_devote_exalted_hero_to_khorne"] = true,
			["wh3_dlc20_character_initiative_devote_lord_to_khorne"] = true
		} 
	},
	wh3_dlc20_chs_vilitch 	= {
		advice = "wh3_dlc20_vilitch_cam_mission_glory_001", 
		mission = "wh3_dlc20_camp_narrative_champions_path_to_glory_vilitch", 
		objective_text = "wh3_dlc20_camp_narrative_mission_description_champions_path_to_glory_vilitch", 
		reward = {payload.mercenary_mission_payload("wh3_main_tze_mon_flamers_0", 2), payload.money_direct(2000)}, 
		initiatives = {
			["wh3_dlc24_character_initiative_devote_exalted_hero_to_tzeentch"] = true,
			["wh3_dlc24_character_initiative_devote_lord_to_tzeentch"] = true,
			["wh3_dlc20_character_initiative_devote_sorceror_lord_to_tzeentch_metal"] = true,
			["wh3_dlc20_character_initiative_devote_sorceror_lord_to_tzeentch_tzeentch"] = true, 
			["wh3_dlc20_character_initiative_devote_sorceror_to_tzeentch_metal"] = true, 
			["wh3_dlc20_character_initiative_devote_sorceror_to_tzeentch_tzeentch"] = true
		} 
	}, 
}

coc_narrative_missions.war_coordination = {
	wh3_dlc20_chs_azazel  	= {
		advice = nil,
		reward = {payload.money_direct(2000)}, 
	},
	wh3_dlc20_chs_festus 	= {
		advice = nil, 
		reward = {payload.pooled_resource_mission_payload("wh3_main_nur_infections", "events", 50), payload.money_direct(2000)}, 
	},
	wh3_dlc20_chs_valkia 	= {
		advice = nil, 
		reward = {payload.money_direct(2000)}, 
	},
	wh3_dlc20_chs_vilitch 	= {
		advice = nil, 
		reward = {payload.money_direct(2000)}, 
	}, 
}

coc_narrative_missions.gain_dark_fortress = {
	wh3_dlc20_chs_azazel  	= {
		advice = "wh3_dlc20_azazel_cam_mission_fortresses_001",
		reward = {payload.effect_bundle_mission_payload("wh2_main_payload_growth_positive_all_province", 10), payload.money_direct(5000)}, 
	},
	wh3_dlc20_chs_festus 	= {
		advice = "wh3_dlc20_festus_cam_mission_fortresses_001", 
		reward = {payload.effect_bundle_mission_payload("wh2_main_payload_growth_positive_all_province", 10), payload.money_direct(5000)}, 
	},
	wh3_dlc20_chs_valkia 	= {
		advice = "wh3_dlc20_valkia_cam_mission_fortresses_001", 
		reward = {payload.effect_bundle_mission_payload("wh2_main_payload_growth_positive_all_province", 10), payload.money_direct(5000)}, 
	},
	wh3_dlc20_chs_vilitch 	= {
		advice = "wh3_dlc20_vilitch_cam_mission_fortresses_001", 
		reward = {payload.effect_bundle_mission_payload("wh2_main_payload_growth_positive_all_province", 10), payload.money_direct(5000)}, 
	}, 
}

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--
--	Start all Chains
--
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


local function start_champions_narrative_events(faction_key)

----------------------------------------------------
--					CHAOS GIFTS					  --
----------------------------------------------------

	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown Sacrifice Souls
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "champions_sacrifice_souls_trigger_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,														-- unique name for this narrative trigger
				faction_key,												-- key of faction to which it applies
				"StartNarrativeEvents",										-- script message(s) on which to start
				"ScriptEventStartChampions_SacrificeSouls",					-- target message(s) to trigger
				nil,														-- script message(s) on which to cancel
				3,															-- num turns to wait
				true														-- trigger immediately
			);
		end;
	end;

	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown Gain Chaos Gift Slot
	-----------------------------------------------------------------------------------------------------------

	do
		local name = "champions_gain_chaos_gift_slot_trigger_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,														-- unique name for this narrative trigger
				faction_key,												-- key of faction to which it applies
				"StartNarrativeEvents",										-- script message(s) on which to start
				"ScriptEventStartChampions_GainChaosGiftSlot",				-- target message(s) to trigger
				nil,														-- script message(s) on which to cancel
				9,															-- num turns to wait
				true														-- trigger immediately
			);
		end;
	end;

----------------------------------------------------
--				WARBANDS & DARK AUTHORITY		  --
----------------------------------------------------
	
	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown Mark Units
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "champions_mark_units_trigger_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,														-- unique name for this narrative trigger
				faction_key,												-- key of faction to which it applies
				"StartNarrativeEvents",										-- script message(s) on which to start
				"ScriptEventStartChampions_MarkUnits",						-- target message(s) to trigger
				nil,														-- script message(s) on which to cancel
				1,															-- num turns to wait
				true														-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown Upgrade Units
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "champions_upgrade_units_trigger_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,														-- unique name for this narrative trigger
				faction_key,												-- key of faction to which it applies
				"StartNarrativeEvents",										-- script message(s) on which to start
				"ScriptEventStartChampions_UpgradeUnits",					-- target message(s) to trigger
				nil,														-- script message(s) on which to cancel
				5,															-- num turns to wait
				true														-- trigger immediately
			);
		end;
	end;


	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown Increase Dark Authority
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "champions_increase_dark_authority_trigger_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,														-- unique name for this narrative trigger
				faction_key,												-- key of faction to which it applies
				"StartNarrativeEvents",										-- script message(s) on which to start
				"ScriptEventStartChampions_IncreaseDarkAuthority",			-- target message(s) to trigger
				nil,														-- script message(s) on which to cancel
				7,															-- num turns to wait
				true														-- trigger immediately
			);
		end;
	end;

----------------------------------------------------
--					PATH TO GLORY				  --
----------------------------------------------------

	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown Path to Glory
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "champions_path_to_glory_trigger_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,														-- unique name for this narrative trigger
				faction_key,												-- key of faction to which it applies
				"StartNarrativeEvents",										-- script message(s) on which to start
				"ScriptEventStartChampions_PathToGlory",					-- target message(s) to trigger
				nil,														-- script message(s) on which to cancel
				7,															-- num turns to wait
				true														-- trigger immediately
			);
		end;
	end;

----------------------------------------------------
--	DARK FORTRESSES, NORSCAN HOMELANDS & VASSALS  --
----------------------------------------------------

	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown War Coordination
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "champions_war_coordination_trigger_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,														-- unique name for this narrative trigger
				faction_key,												-- key of faction to which it applies
				"StartNarrativeEvents",										-- script message(s) on which to start
				"ScriptEventStartChampions_WarCoordination",				-- target message(s) to trigger
				nil,														-- script message(s) on which to cancel
				3,															-- num turns to wait
				true														-- trigger immediately
			);
		end;
	end;

	-----------------------------------------------------------------------------------------------------------
	--	Turn Countdown Gain Dark Fortress
	-----------------------------------------------------------------------------------------------------------
	
	do
		local name = "champions_gain_dark_fortress_trigger_turn_countdown";

		if not narrative.get(faction_key, name .. "_block") then
			narrative_triggers.turn_countdown(
				name,														-- unique name for this narrative trigger
				faction_key,												-- key of faction to which it applies
				"StartNarrativeEvents",										-- script message(s) on which to start
				"ScriptEventStartChampions_GainDarkFortress",				-- target message(s) to trigger
				nil,														-- script message(s) on which to cancel
				5,															-- num turns to wait
				true														-- trigger immediately
			);
		end;
	end;


	coc_narrative_missions:initialise(faction_key)
end


function coc_narrative_missions:initialise(faction_key)

----------------------------------------------------
--					CHAOS GIFTS					  --
----------------------------------------------------
	
	--Sacrifice Souls 
	do
		local name = "champions_event_sacrifice_souls";
		local mission_info = self.sacrifice_souls[faction_key]

		if mission_info and not narrative.get(faction_key, name .. "_block") then
			narrative_events.generic(
				name,														-- unique name for this narrative event
				faction_key,												-- key of faction to which it applies
				mission_info.advice,										-- key of advice to deliver
				mission_info.mission,										-- key of mission to deliver
				mission_info.objective_text,								-- key of mission objective text
				{															-- event/condition listeners
					{
						event = "ScriptEventTrackedPooledResourceChanged",
						condition =	function(context)
							local resource = context:resource()
							local faction = context:faction()
							if faction ~= nil then
								return resource:key() == mission_info.pooled_resource and faction:name() == faction_key and resource:value() >= 1000;
							end
							return false
						end
					}
				},
				nil,														-- camera scroll callback
				nil,														-- mission issuer (can be nil in which case default is used)
				mission_info.reward,										-- mission rewards
				"ScriptEventStartChampions_SacrificeSouls",					-- script message(s) on which to trigger when received
				nil,														-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				nil,														-- script message(s) to trigger when this mission is completed
				nil,
				true 														-- force the advice to always play
			);
		end
	end;

	--Gain Chaos Gift Slot
	do
		local name = "champions_event_gain_chaos_gift_slot";
		local mission_info = self.gain_chaos_gift_slot[faction_key]

		if mission_info and not narrative.get(faction_key, name .. "_block") then
			narrative_events.generic(
				name,														-- unique name for this narrative event
				faction_key,												-- key of faction to which it applies
				mission_info.advice,										-- key of advice to deliver
				mission_info.mission,										-- key of mission to deliver
				mission_info.objective_text,								-- key of mission objective text
				{															-- event/condition listeners
					{
						event = "ResearchCompleted",
						condition =	function(context)
							local technology = context:technology()
							return context:faction():name() == faction_key and mission_info.technologies[technology]
						end
					}
				},
				nil,														-- camera scroll callback
				nil,														-- mission issuer (can be nil in which case default is used)
				mission_info.reward,										-- mission rewards
				"ScriptEventStartChampions_GainChaosGiftSlot",				-- script message(s) on which to trigger when received
				nil,														-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				nil,														-- script message(s) to trigger when this mission is completed
				nil,
				true 														-- force the advice to always play
			);
		end
	end;

----------------------------------------------------
--				WARBANDS & DARK AUTHORITY		  --
----------------------------------------------------
	
	--Mark Units 
	do
		local name = "champions_event_mark_units";
		local mission_info = self.mark_units[faction_key]

		if mission_info and not narrative.get(faction_key, name .. "_block") then
			narrative_events.generic(
				name,														-- unique name for this narrative event
				faction_key,												-- key of faction to which it applies
				mission_info.advice,										-- key of advice to deliver
				mission_info.mission,										-- key of mission to deliver
				mission_info.objective_text,								-- key of mission objective text
				{															-- event/condition listeners
					{
						event = "UnitConverted",
						condition =	function(context)
							local unit = context:unit()
							local converted_unit_key = context:converted_unit():unit_key()

							if unit:faction():name() == faction_key then
								if not unit:unit_key():find(mission_info.mark_key) and converted_unit_key:find(mission_info.mark_key)  then
									mission_info.num_marked_units = mission_info.num_marked_units + 1
								end

								return mission_info.num_marked_units >= 3
							end
						end
					}
				},
				nil,														-- camera scroll callback
				nil,														-- mission issuer (can be nil in which case default is used)
				mission_info.reward,										-- mission rewards
				"ScriptEventStartChampions_MarkUnits",						-- script message(s) on which to trigger when received
				nil,														-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				nil,														-- script message(s) to trigger when this mission is completed
				nil,
				true 														-- force the advice to always play
			);
		end
	end;

	--Upgrade Units
	do
		local name = "champions_event_upgrade_units";
		local mission_info = self.upgrade_units[faction_key]

		if mission_info and not narrative.get(faction_key, name .. "_block") then
			narrative_events.generic(
				name,														-- unique name for this narrative event
				faction_key,												-- key of faction to which it applies
				mission_info.advice,										-- key of advice to deliver
				mission_info.mission,										-- key of mission to deliver
				mission_info.objective_text,								-- key of mission objective text
				{															-- event/condition listeners
					{
						event = "UnitConverted",
						condition =	function(context)
							local unit = context:unit()
							local converted_unit_key = context:converted_unit():unit_key()
							
							if unit:faction():name() == faction_key then
								if unit:unit_key():find("inf_chaos_marauders_") and converted_unit_key:find("inf_chaos_warriors") then
									mission_info.num_upgraded_units = mission_info.num_upgraded_units + 1
								end
							end

							return mission_info.num_upgraded_units >= 3
						end
					}
				},
				nil,														-- camera scroll callback
				nil,														-- mission issuer (can be nil in which case default is used)
				mission_info.reward,										-- mission rewards
				"ScriptEventStartChampions_UpgradeUnits",					-- script message(s) on which to trigger when received
				nil,														-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				nil,														-- script message(s) to trigger when this mission is completed
				nil,
				true 														-- force the advice to always play
			);
		end
	end;


	--Improve Dark Authority
	do
		local name = "champions_event_increase_dark_authority";
		local mission_info = self.increase_dark_authority[faction_key]

		if mission_info and not narrative.get(faction_key, name .. "_block") then
			narrative_events.generic(
				name,														-- unique name for this narrative event
				faction_key,												-- key of faction to which it applies
				mission_info.advice,										-- key of advice to deliver
				mission_info.mission,										-- key of mission to deliver
				mission_info.objective_text,								-- key of mission objective text
				{															-- event/condition listeners
					{
						event = "PooledResourceEffectChangedEvent",
						condition =	function(context)
							local resource = context:resource()
							local resource_name = context:resource():key()
							return (resource_name == mission_info.pooled_resource or resource_name == "wh3_dlc20_chs_authority_undivided") and context:faction():name() == faction_key and resource:value() >= 6;
						end
					}
				},
				nil,														-- camera scroll callback
				nil,														-- mission issuer (can be nil in which case default is used)
				mission_info.reward,										-- mission rewards
				"ScriptEventStartChampions_IncreaseDarkAuthority",			-- script message(s) on which to trigger when received
				nil,														-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				nil,														-- script message(s) to trigger when this mission is completed
				nil
			);
		end
	end;

----------------------------------------------------
--					PATH TO GLORY				  --
----------------------------------------------------
	--Mark/Ascend a character
	do
		local name = "champions_event_path_to_glory";
		local mission_info = self.path_to_glory[faction_key]

		if mission_info and not narrative.get(faction_key, name .. "_block") then
			narrative_events.generic(
				name,														-- unique name for this narrative event
				faction_key,												-- key of faction to which it applies
				mission_info.advice,										-- key of advice to deliver
				mission_info.mission,										-- key of mission to deliver
				mission_info.objective_text,								-- key of mission objective text
				{															-- event/condition listeners
					{
						event = "CharacterInitiativeActivationChangedEvent",
						condition =	function(context)						
							local initiative = context:initiative():record_key()
							return context:character():faction():name() == faction_key and mission_info.initiatives[initiative]
						end
					}
				},
				nil,														-- camera scroll callback
				nil,														-- mission issuer (can be nil in which case default is used)
				mission_info.reward,										-- mission rewards
				"ScriptEventStartChampions_PathToGlory",					-- script message(s) on which to trigger when received
				nil,														-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				nil,														-- script message(s) to trigger when this mission is completed
				nil,
				true 														-- force the advice to always play
			);
		end
	end;

----------------------------------------------------
--	DARK FORTRESSES, NORSCAN HOMELANDS & VASSALS  --
----------------------------------------------------

	--War Coordination
	do
		local name = "champions_event_war_coordination";
		local mission_info = self.war_coordination[faction_key]

		if mission_info and not narrative.get(faction_key, name .. "_block") then
			narrative_events.generic(
				name,																			-- unique name for this narrative event
				faction_key,																	-- key of faction to which it applies
				mission_info.advice,															-- key of advice to deliver
				"wh3_dlc20_camp_narrative_champions_war_coordination",							-- key of mission to deliver
				"wh3_dlc20_camp_narrative_mission_description_champions_war_coordination",		-- key of mission objective text
				{																				-- event/condition listeners
					{
						event = "WarCoordinationRequestIssued",
						condition =	function(context)					
							return context:faction():name() == faction_key
						end
					}
				},
				nil,														-- camera scroll callback
				nil,														-- mission issuer (can be nil in which case default is used)
				mission_info.reward,										-- mission rewards
				"ScriptEventStartChampions_WarCoordination",				-- script message(s) on which to trigger when received
				nil,														-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				nil,														-- script message(s) to trigger when this mission is completed
				nil
			);
		end
	end;

	--Gain Dark Fortress
	do
		local name = "champions_event_gain_dark_fortress";
		local mission_info = self.gain_dark_fortress[faction_key]

		if mission_info and not narrative.get(faction_key, name .. "_block") then
			narrative_events.generic(
				name,																			-- unique name for this narrative event
				faction_key,																	-- key of faction to which it applies
				mission_info.advice,															-- key of advice to deliver
				"wh3_dlc20_camp_narrative_champions_gain_dark_fortress",						-- key of mission to deliver
				"wh3_dlc20_camp_narrative_champions_mission_description_gain_dark_fortress",	-- key of mission objective text
				{																				-- event/condition listeners
					{
						event = "CharacterPerformsSettlementOccupationDecision",
						condition =	function(context)	
							local occupation_decision = context:occupation_decision_type();
							if occupation_decision == "occupation_decision_occupy" or occupation_decision == "occupation_decision_occupy_and_vassal" or occupation_decision == "occupation_decision_colonise" then
								return context:character():faction():name() == faction_key and context:garrison_residence():region():is_contained_in_region_group("wh3_dlc20_dark_fortress_region_group")
							end
							return false
						end
					}
				},
				nil,														-- camera scroll callback
				nil,														-- mission issuer (can be nil in which case default is used)
				mission_info.reward,										-- mission rewards
				"ScriptEventStartChampions_GainDarkFortress",				-- script message(s) on which to trigger when received
				nil,														-- script message(s) to trigger when this narrative event has finished issuing (may be nil)
				nil,														-- script message(s) to trigger when this mission is completed
				nil,
				true 														-- force the advice to always play
			);
		end
	end;

end;


-- Ensure that these narrative events are started for any player-controlled faction matching the culture
narrative.add_loader_for_culture("wh_main_chs_chaos", start_champions_narrative_events);


--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("NarrativeChampionsMissions_MarkUnits", coc_narrative_missions.mark_units, context)
		cm:save_named_value("NarrativeChampionsMissions_UpgradeUnits", coc_narrative_missions.upgrade_units, context)
	end
);
cm:add_loading_game_callback(
	function(context)
		if not cm:is_new_game() then
			champions_narrative.mark_units = cm:load_named_value("NarrativeChampionsMissions_MarkUnits", coc_narrative_missions.mark_units, context)
			champions_narrative.upgrade_units = cm:load_named_value("NarrativeChampionsMissions_UpgradeUnits", coc_narrative_missions.upgrade_units, context)
		end
	end
)