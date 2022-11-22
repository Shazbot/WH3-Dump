-- additional helper functions for advanced rite features

-- rite unlocking system
rite_unlock = {
	cm = false,
	faction_name = "",
	rite_key = "",
	event = "",
	condition = false
};

function rite_unlock_listeners()
	local rite_templates = {
		-------------
		-- asuryan --
		-------------
		{
			["culture"] = "wh2_main_hef_high_elves",
			["rite_name"] = "wh2_main_ritual_hef_asuryan",
			["event_name"] = "CharacterRankUp",
			["condition"] =
				function(context, faction_name)
					local character = context:character();
					
					return character:faction():name() == faction_name and character:is_faction_leader() and character:rank() >= 5;
				end,
			["show_unlock_message"] = true
		},
		-----------
		-- lileath --
		-----------
		{
			["culture"] = "wh2_main_hef_high_elves",
			["rite_name"] = "wh2_dlc10_ritual_hef_lileath",
			["event_name"] = "BuildingCompleted",
			["condition"] =
				function(context, faction_name)
					local building = context:building();
					
					return building:faction():name() == faction_name and building:name() == "wh2_dlc10_special_world_root_entrance_2";
				end,
			["show_unlock_message"] = true
		},
		-----------
		-- hoeth --
		-----------
		{
			["culture"] = "wh2_main_hef_high_elves",
			["rite_name"] = "wh2_main_ritual_hef_hoeth",
			["event_name"] = "BuildingCompleted",
			["condition"] =
				function(context, faction_name)
					local building = context:building();
					
					return building:faction():name() == faction_name and building:name() == "wh2_main_hef_mages_1";
				end,
			["show_unlock_message"] = true
		},
		{
			["culture"] = "wh2_main_hef_high_elves",
			["rite_name"] = "wh2_main_ritual_hef_hoeth",
			["event_name"] = "GarrisonOccupiedEvent",
			["condition"] =
				function(context, faction_name)
					local region = context:garrison_residence():region();
					
					return context:character():faction():name() == faction_name and (
						region:building_exists("wh2_main_hef_mages_1") or
						region:building_exists("wh2_main_hef_mages_2") or
						region:building_exists("wh2_main_hef_mages_3")
					);
				end,
			["show_unlock_message"] = true
		},
		----------
		-- isha --
		----------
		{
			["culture"] = "wh2_main_hef_high_elves",
			["rite_name"] = "wh2_main_ritual_hef_isha",
			["event_name"] = "GarrisonOccupiedEvent",
			["condition"] =
				function(context, faction_name)
					local faction = context:character():faction();
					
					return faction:name() == faction_name and faction:region_list():num_items() >= 3;
				end,
			["show_unlock_message"] = true
		},

		--------------------
		-- isha (greater) --
		--------------------
		{
			["culture"] = "wh2_main_hef_high_elves",
			["rite_name"] = "wh2_dlc15_ritual_hef_isha_greater",
			["event_name"] = "GarrisonOccupiedEvent",
			["condition"] =
				function(context, faction_name)
					local faction = context:character():faction();
					
					return faction:name() == faction_name and faction:region_list():num_items() >= 3;
				end,
			["show_unlock_message"] = true
		},
		---------------
		-- morai heg --
		---------------
		{
			["culture"] = "wh2_main_hef_high_elves",
			["rite_name"] = "wh2_dlc10_ritual_hef_morai_heg",
			["event_name"] = "FactionLeaderIssuesEdict",
			["condition"] =
			function(context, faction_name)
				return context:faction():name() == faction_name and context:initiative_key() == "wh2_main_edict_hef_reaver_patrols";
			end,
			["show_unlock_message"] = true
		},
		----------
		-- vaul --
		----------
		{
			["culture"] = "wh2_main_hef_high_elves",
			["rite_name"] = "wh2_main_ritual_hef_vaul",
			["event_name"] = "ResearchCompleted",
			["condition"] =
				function(context, faction_name)
					if context:faction():name() == faction_name then
						local tech_count = cm:get_saved_value("rite_vaul_tech_count_" .. faction_name) or 0;
						
						tech_count = tech_count + 1;
						
						cm:set_saved_value("rite_vaul_tech_count_" .. faction_name, tech_count);
						
						return tech_count >= 3;
					end;
				end,
			["show_unlock_message"] = true
		},
		--------------------
		-- vaul (greater) --
		--------------------
		{
			["culture"] = "wh2_main_hef_high_elves",
			["rite_name"] = "wh2_dlc15_ritual_hef_vaul_greater",
			["event_name"] = "ResearchCompleted",
			["condition"] =
				function(context, faction_name)
					if context:faction():name() == faction_name then
						local tech_count = cm:get_saved_value("rite_vaul_tech_count_" .. faction_name) or 0;
						
						tech_count = tech_count + 1;
						
						cm:set_saved_value("rite_vaul_tech_count_" .. faction_name, tech_count);
						
						return tech_count >= 3;
					end;
				end,
			["show_unlock_message"] = true
		},
		--------------
		-- eldrazor --
		--------------
		{
			["culture"] = "wh2_main_hef_high_elves",
			["rite_name"] = "wh2_dlc15_ritual_hef_eldrazor",
			["event_name"] = "CharacterCompletedBattle",
			["condition"] =
				function(context, faction_name)
					local character = context:character();
					
					return character:faction():name() == faction_name and character:battles_won() >= 3;
				end,
			["show_unlock_message"] = true
		},
		---------------
		-- ladrielle --
		---------------
		{
			["culture"] = "wh2_main_hef_high_elves",
			["rite_name"] = "wh2_dlc15_ritual_hef_ladrielle",
			["event_name"] = "PooledResourceEffectChangedEvent",
			["condition"] =
				function(context, faction_name)
					if context:has_faction() then
						local faction = context:faction();
						if faction:name() == faction_name and string.match(context:new_effect(),"wh2_dlc15_bundle_yvresse_defence.*") then
							core:trigger_event("ScriptEventMistsOfYvresseUnlocked");
							return true;
						end;
					end;
					return false;					
				end,
			["show_unlock_message"] = true
		},
		-------------
		-- atharti --
		-------------
		{
			["culture"] = "wh2_main_def_dark_elves",
			["rite_name"] = "wh2_main_ritual_def_atharti",
			["event_name"] = "FactionLeaderIssuesEdict",
			["condition"] =
				function(context, faction_name)
					return context:faction():name() == faction_name and context:initiative_key() == "wh2_main_edict_def_demand_hostages";
				end,
			["show_unlock_message"] = true
		},
		-------------
		-- drakira --
		-------------
		{
			["culture"] = "wh2_main_def_dark_elves",
			["rite_name"] = "wh2_dlc10_ritual_def_drakira",
			["event_name"] = "CharacterRankUp",
			["condition"] =
				function(context, faction_name)					
					local character = context:character();
					
					return character:faction():name() == faction_name and character:is_faction_leader() and character:rank() >= 12;
				end,
			["show_unlock_message"] = true
		},
		-------------
		-- hekarti --
		-------------
		{
			["culture"] = "wh2_main_def_dark_elves",
			["rite_name"] = "wh2_main_ritual_def_hekarti",
			["event_name"] = "CharacterCharacterTargetAction",
			["condition"] =
				function(context, faction_name)
					local character = context:character();
					
					return character:faction():name() == faction_name and character:character_type("wizard");
				end,
			["show_unlock_message"] = true
		},
		{
			["culture"] = "wh2_main_def_dark_elves",
			["rite_name"] = "wh2_main_ritual_def_hekarti",
			["event_name"] = "CharacterGarrisonTargetAction",
			["condition"] =
				function(context, faction_name)
					local character = context:character();
					
					return character:faction():name() == faction_name and character:character_type("wizard");
				end,
			["show_unlock_message"] = true
		},
		------------
		-- khaine --
		------------
		{
			["culture"] = "wh2_main_def_dark_elves",
			["rite_name"] = "wh2_main_ritual_def_khaine",
			["event_name"] = "CharacterPostBattleCaptureOption",
			["condition"] =
				function(context, faction_name)
					if context:get_outcome_key() == "enslave" and context:character():faction():name() == faction_name then
						local enslave_count = cm:get_saved_value("rite_khaine_enslave_count_" .. faction_name) or 0;
						
						enslave_count = enslave_count + 1;
						
						cm:set_saved_value("rite_khaine_enslave_count_" .. faction_name, enslave_count);
						
						return enslave_count > 2;
					end;
				end,
			["show_unlock_message"] = true
		},
		--------------
		-- mathlann --
		--------------
		{
			["culture"] = "wh2_main_def_dark_elves",
			["rite_name"] = "wh2_main_ritual_def_mathlann",
			["event_name"] = "BuildingCompleted",
			["condition"] =
				function(context, faction_name)
					local building = context:building();
					
					return building:faction():name() == faction_name and building:name() == "wh2_main_def_slaves_1";
				end,
			["show_unlock_message"] = true
		},
		{
			["culture"] = "wh2_main_def_dark_elves",
			["rite_name"] = "wh2_main_ritual_def_mathlann",
			["event_name"] = "GarrisonOccupiedEvent",
			["condition"] =
				function(context, faction_name)
					local region = context:garrison_residence():region();
					
					return context:character():faction():name() == faction_name and (region:building_exists("wh2_main_def_slaves_1") or region:building_exists("wh2_main_def_slaves_2"));
				end,
			["show_unlock_message"] = true
		},
		-----------------
		-- anath raema --
		-----------------
		{
			["culture"] = "wh2_main_def_dark_elves",
			["rite_name"] = "wh2_dlc11_ritual_def_anath_raema",
			["event_name"] = "CharacterRankUp",
			["condition"] =
				function(context, faction_name)
					local character = context:character();
					
					return character:faction():name() == faction_name and character:is_faction_leader() and character:rank() >= 12;
				end,
			["show_unlock_message"] = true
		},		
		-----------------
		--  witch king --
		-----------------
		{
			["culture"] = "wh2_main_def_dark_elves",
			["rite_name"] = "wh2_dlc14_ritual_def_witch_king",
			["event_name"] = "CharacterRankUp",
			["condition"] =
				function(context, faction_name)
					local character = context:character();
					
					if character:faction():name() == faction_name and character:is_faction_leader() and character:rank() >= 5 then
						core:trigger_event("ScriptEventWitchKingRiteUnlocked");
						return true;
					end
				end,
			["show_unlock_message"] = true
		},

		-----------------
		--  beast hunt --
		-----------------
		{
			["culture"] = "wh2_main_def_dark_elves",
			["rite_name"] = "wh2_twa03_ritual_def_beasthunt",
			["event_name"] = "ScriptEventRakarthBeastIncidentGenerated",
			["condition"] =
				function(context, faction_name)					
					if RakarthBeastHunts.incident_count >= RakarthBeastHunts.beast_incidents_for_rite then
						core:trigger_event("ScriptEventRakarthRiteUnlocked");
						return true
					end
				end,
			["show_unlock_message"] = true,
		},
		----------------
		-- ascendancy --
		----------------
		{
			["culture"] = "wh2_main_skv_skaven",
			["rite_name"] = "wh2_main_ritual_skv_ascendancy",
			["event_name"] = "FactionLeaderIssuesEdict",
			["condition"] =
				function(context, faction_name)
					return context:faction():name() == faction_name and context:initiative_key() == "wh2_main_edict_skv_expansionist_planning";
				end,
			["show_unlock_message"] = true
		},
		------------
		-- doooom --
		------------
		{
			["culture"] = "wh2_main_skv_skaven",
			["rite_name"] = "wh2_main_ritual_skv_doooom",
			["event_name"] = "ResearchCompleted",
			["condition"] =
				function(context, faction_name)
					if context:faction():name() == faction_name then
						local tech_count = cm:get_saved_value("rite_doooom_tech_count_" .. faction_name) or 0;
						
						tech_count = tech_count + 1;
						
						cm:set_saved_value("rite_doooom_tech_count_" .. faction_name, tech_count);
						
						return tech_count >= 3;
					end;
				end,
			["show_unlock_message"] = true
		},
		----------------
		-- pestilence --
		----------------
		{
			["culture"] = "wh2_main_skv_skaven",
			["rite_name"] = "wh2_main_ritual_skv_pestilence",
			["event_name"] = "BuildingCompleted",
			["condition"] =
				function(context, faction_name)
					local building = context:building();
					
					return building:faction():name() == faction_name and building:name() == "wh2_main_skv_plagues_2";
				end,
			["show_unlock_message"] = true
		},
		{
			["culture"] = "wh2_main_skv_skaven",
			["rite_name"] = "wh2_main_ritual_skv_pestilence",
			["event_name"] = "GarrisonOccupiedEvent",
			["condition"] =
				function(context, faction_name)
					local region = context:garrison_residence():region();
					
					return context:character():faction():name() == faction_name and (region:building_exists("wh2_main_skv_plagues_2") or region:building_exists("wh2_main_skv_plagues_3"));
				end,
			["show_unlock_message"] = true
		},
		----------------
		-- pestilence (pestilens) --
		----------------
		{
			["culture"] = "wh2_main_skv_skaven",
			["rite_name"] = "wh2_dlc14_ritual_skv_pestilence_pestilens",
			["event_name"] = "BuildingCompleted",
			["condition"] =
				function(context, faction_name)
					local building = context:building();
					
					return building:faction():name() == faction_name and building:name() == "wh2_main_skv_plagues_1";
				end,
			["show_unlock_message"] = true
		},
		{
			["culture"] = "wh2_main_skv_skaven",
			["rite_name"] = "wh2_dlc14_ritual_skv_pestilence_pestilens",
			["event_name"] = "GarrisonOccupiedEvent",
			["condition"] =
				function(context, faction_name)
					local region = context:garrison_residence():region();
					
					return context:character():faction():name() == faction_name and (region:building_exists("wh2_main_skv_plagues_1") or region:building_exists("wh2_main_skv_plagues_2") or region:building_exists("wh2_main_skv_plagues_3"));
				end,
			["show_unlock_message"] = true
		},
		---------------------
		-- thirteen (mors) --
		---------------------
		{
			["culture"] = "wh2_main_skv_skaven",
			["rite_name"] = "wh2_main_ritual_skv_thirteen_mors",
			["event_name"] = "CharacterRankUp",
			["condition"] =
				function(context, faction_name)
					local character = context:character();
					
					return character:faction():name() == faction_name and character:is_faction_leader() and character:rank() >= 7;
				end,
			["show_unlock_message"] = true
		},
		--------------------------
		-- thirteen (pestilens) --
		--------------------------
		{
			["culture"] = "wh2_main_skv_skaven",
			["rite_name"] = "wh2_main_ritual_skv_thirteen_pestilens",
			["event_name"] = "CharacterRankUp",
			["condition"] =
				function(context, faction_name)					
					local character = context:character();
					
					return character:faction():name() == faction_name and character:is_faction_leader() and character:rank() >= 7;
				end,
			["show_unlock_message"] = true
		},
		--------------------------
		-- thirteen (rictus) --
		--------------------------
		{
			["culture"] = "wh2_main_skv_skaven",
			["rite_name"] = "wh2_dlc09_ritual_skv_thirteen_rictus",
			["event_name"] = "CharacterRankUp",
			["condition"] =
				function(context, faction_name)					
					local character = context:character();
					
					return character:faction():name() == faction_name and character:is_faction_leader() and character:rank() >= 7;
				end,
			["show_unlock_message"] = true
		},
		--------------------------
		-- thirteen (skryre) --
		--------------------------
		{
			["culture"] = "wh2_main_skv_skaven",
			["rite_name"] = "wh2_main_ritual_skv_thirteen_skryre",
			["event_name"] = "CharacterRankUp",
			["condition"] =
				function(context, faction_name)					
					local character = context:character();
					
					return character:faction():name() == faction_name and character:is_faction_leader() and character:rank() >= 7;
				end,
			["show_unlock_message"] = true
		},
		
		--------------------------
		-- thirteen (eshin) --
		--------------------------
		{
			["culture"] = "wh2_main_skv_skaven",
			["rite_name"] = "wh2_main_ritual_skv_thirteen_eshin",
			["event_name"] = "CharacterRankUp",
			["condition"] =
				function(context, faction_name)					
					local character = context:character();
					
					return character:faction():name() == faction_name and character:is_faction_leader() and character:rank() >= 7;
				end,
			["show_unlock_message"] = true
		},

		--------------------------
		-- thirteen (moulder) --
		--------------------------
		{
			["culture"] = "wh2_main_skv_skaven",
			["rite_name"] = "wh2_main_ritual_skv_thirteen_moulder",
			["event_name"] = "CharacterRankUp",
			["condition"] =
				function(context, faction_name)					
					local character = context:character();
					
					return character:faction():name() == faction_name and character:is_faction_leader() and character:rank() >= 7;
				end,
			["show_unlock_message"] = true
		},
		---------------
		-- awakening --
		---------------
		{
			["culture"] = "wh2_main_lzd_lizardmen",
			["rite_name"] = "wh2_main_ritual_lzd_awakening",
			["event_name"] = "FactionTurnStart",
			["condition"] =
			function(context, faction_name)
				local faction = context:faction();
				
				if faction:name() == faction_name then
					local mf_list = faction:military_force_list();
					local units = 0;
					
					for i = 0, mf_list:num_items() - 1 do
						local current_mf = mf_list:item_at(i);
						
						if current_mf:has_general() and not current_mf:is_armed_citizenry() then
							units = units + current_mf:unit_list():num_items();
						end;
					end;
					
					return units > 19;
				end;
			end,
		["show_unlock_message"] = true
		},
		--------------
		-- ferocity --
		--------------
		{
			["culture"] = "wh2_main_lzd_lizardmen",
			["rite_name"] = "wh2_main_ritual_lzd_ferocity",
			["event_name"] = "CharacterCompletedBattle",
			["condition"] =
				function(context, faction_name)
					local character = context:character();
					
					return character:faction():name() == faction_name and character:battles_won() >= 3;
				end,
			["show_unlock_message"] = true
		},
		--------------------
		-- primeval glory --
		--------------------
		{
			["culture"] = "wh2_main_lzd_lizardmen",
			["rite_name"] = "wh2_main_ritual_lzd_primeval_glory",
			["event_name"] = "UnitCreated",
			["condition"] =
				function(context, faction_name)
					local unit = context:unit();
					
					return unit:faction():name() == faction_name and string.find(unit:unit_key(), "_blessed");
				end,
			["show_unlock_message"] = true
		},
		-----------
		-- sotek --
		-----------
		{
			["culture"] = "wh2_main_lzd_lizardmen",
			["rite_name"] = "wh2_main_ritual_lzd_sotek",
			["event_name"] = "UnitCreated",
			["condition"] =
				function(context, faction_name)	
					local unit = context:unit();
					local unit_count = cm:get_saved_value("rite_sotek_unit_count_" .. faction_name) or 0;
					
					if unit:faction():name() == faction_name and string.find(unit:unit_key(), "_skink") and string.find(unit:unit_key(), "_inf_") then
						unit_count = unit_count + 1;		
						cm:set_saved_value("rite_sotek_unit_count_" .. faction_name, unit_count);
					end;
					
					return unit_count >= 3;
				end,
			["show_unlock_message"] = true
		},
		
		-----------------
		-- Tzunkii --
		-----------------
		{
			["culture"] = "wh2_main_lzd_lizardmen",
			["rite_name"] = "wh2_dlc12_lzd_tiktaqto_ritual_persistence",
			["event_name"] = "CharacterRankUp",
			["condition"] =
				function(context, faction_name)
					local character = context:character();
					
					return character:faction():name() == faction_name and character:is_faction_leader() and character:rank() >= 5;
				end,
			["show_unlock_message"] = true
		},
		
		-----------
		-- mastery --
		-----------
		{
			["culture"] = "wh2_main_lzd_lizardmen",
			["rite_name"] = "wh2_dlc13_rituals_lzd_mastery",
			["event_name"] = "UnitCreated",
			["condition"] =
				function(context, faction_name)	
					local unit = context:unit();
					local unit_count = cm:get_saved_value("rite_mastery_unit_count_" .. faction_name) or 0;
					
					if unit:faction():name() == faction_name and string.find(unit:unit_key(), "_kroxigors") and string.find(unit:unit_key(), "_mon_") then
						unit_count = unit_count + 1;		
						cm:set_saved_value("rite_mastery_unit_count_" .. faction_name, unit_count);
					end;
					
					return unit_count >= 3;
				end,
			["show_unlock_message"] = true
		},
		
		-----------
		-- allegiance --
		-----------
		{
			["culture"] = "wh2_main_lzd_lizardmen",
			["rite_name"] = "wh2_dlc13_rituals_lzd_allegiance",
			["event_name"] = "CharacterRankUp",
			["condition"] =
				function(context, faction_name)
					local character = context:character();
					
					return character:faction():name() == faction_name and character:is_faction_leader() and character:rank() >= 3;
				end,
			["show_unlock_message"] = true
		},
		
		-----------
		-- rebirth --
		-----------
		{
			["culture"] = "wh2_main_lzd_lizardmen",
			["rite_name"] = "wh2_dlc13_rituals_lzd_rebirth",
			["event_name"] = "CharacterRankUp",
			["condition"] =
				function(context, faction_name)
					local character = context:character();
					
					return character:faction():name() == faction_name and character:is_faction_leader() and character:rank() >= 7;
				end,
			["show_unlock_message"] = true
		},
		
		-----------
		-- resilience --
		-----------
		{
			["culture"] = "wh2_main_lzd_lizardmen",
			["rite_name"] = "wh2_dlc13_rituals_lzd_resilience",
			["event_name"] = "CharacterRankUp",
			["condition"] =
				function(context, faction_name)
					local character = context:character();
					
					return character:faction():name() == faction_name and character:is_faction_leader() and character:rank() >= 5;
				end,
			["show_unlock_message"] = true
		},
		
		-----------
		-- khsar --
		-----------
		{
			["culture"] = "wh2_dlc09_tmb_tomb_kings",
			["rite_name"] = "wh2_dlc09_ritual_tmb_khsar",
			["event_name"] = "GarrisonOccupiedEvent",
			["condition"] =
				function(context, faction_name)
					local faction = context:character():faction();
					
					return faction:name() == faction_name and faction:region_list():num_items() >= 3;
				end,
			["show_unlock_message"] = true
		},
		-----------
		-- geheb --
		-----------
		{
			["culture"] = "wh2_dlc09_tmb_tomb_kings",
			["rite_name"] = "wh2_dlc09_ritual_tmb_geheb",
			["event_name"] = "BuildingCompleted",
			["condition"] =
				function(context, faction_name)
					local building = context:building();
					
					return building:faction():name() == faction_name and building:name() == "wh2_dlc09_tmb_citadel_1";
				end,
			["show_unlock_message"] = true
		},
		{
			["culture"] = "wh2_dlc09_tmb_tomb_kings",
			["rite_name"] = "wh2_dlc09_ritual_tmb_geheb",
			["event_name"] = "GarrisonOccupiedEvent",
			["condition"] =
				function(context, faction_name)
					local region = context:garrison_residence():region();
					
					return context:character():faction():name() == faction_name and region:building_exists("wh2_dlc09_tmb_citadel_1");
				end,
			["show_unlock_message"] = true
		},
		------------
		-- tahoth --
		------------
		{
			["culture"] = "wh2_dlc09_tmb_tomb_kings",
			["rite_name"] = "wh2_dlc09_ritual_tmb_tahoth",
			["event_name"] = "FactionTurnStart",
			["condition"] =
				function(context, faction_name)
					local faction = context:faction();
					
					if faction:name() == faction_name then
						local mf_list = faction:military_force_list();
						local units = 0;
						
						for i = 0, mf_list:num_items() - 1 do
							local current_mf = mf_list:item_at(i);
							
							if current_mf:has_general() and not current_mf:is_armed_citizenry() then
								units = units + current_mf:unit_list():num_items();
							end;
						end;
						
						return units > 19;
					end;
				end,
			["show_unlock_message"] = true
		},
		----------
		-- ptra --
		----------
		{
			["culture"] = "wh2_dlc09_tmb_tomb_kings",
			["rite_name"] = "wh2_dlc09_ritual_tmb_ptra",
			["event_name"] = "CharacterCharacterTargetAction",
			["condition"] =
				function(context, faction_name)
					local character = context:character();
					
					return character:faction():name() == faction_name and character:character_type("engineer");
				end,
			["show_unlock_message"] = true
		},
		{
			["culture"] = "wh2_dlc09_tmb_tomb_kings",
			["rite_name"] = "wh2_dlc09_ritual_tmb_ptra",
			["event_name"] = "CharacterGarrisonTargetAction",
			["condition"] =
				function(context, faction_name)
					local character = context:character();
					
					return character:faction():name() == faction_name and character:character_type("engineer");
				end,
			["show_unlock_message"] = true
		},
		------------------------
		-- bountiful treasure --
		------------------------
		{
			["culture"] = "wh2_dlc11_cst_vampire_coast",
			["rite_name"] = "wh2_dlc11_ritual_cst_bountiful_treasure",
			["event_name"] = "BuildingCompleted",
			["condition"] =
				function(context, faction_name)
					local building = context:building();
					local building_name = building:name();
					local faction = building:faction();
					local num_buildings = 0;
					
					if faction:name() == faction_name and
					(building_name == "wh2_dlc11_vampirecoast_infrastructure_income_other_1"
					or building_name == "wh2_dlc11_vampirecoast_infrastructure_income_other_2"
					or building_name == "wh2_dlc11_vampirecoast_infrastructure_income_other_3"
					or building_name == "wh2_dlc11_vampirecoast_infrastructure_income_other_4"
					or building_name == "wh2_dlc11_vampirecoast_infrastructure_income_other_5")
					then
						local region_list = faction:region_list();
						
						for i = 0, region_list:num_items() - 1 do
							local current_region = region_list:item_at(i);
							
							if current_region:building_exists("wh2_dlc11_vampirecoast_infrastructure_income_other_1")
							or current_region:building_exists("wh2_dlc11_vampirecoast_infrastructure_income_other_2")
							or current_region:building_exists("wh2_dlc11_vampirecoast_infrastructure_income_other_3")
							or current_region:building_exists("wh2_dlc11_vampirecoast_infrastructure_income_other_4")
							or current_region:building_exists("wh2_dlc11_vampirecoast_infrastructure_income_other_5")
							then
								num_buildings = num_buildings + 1;
							end;
						end;
					end;
					
					return num_buildings > 2;
				end,
			["show_unlock_message"] = true
		},
		{
			["culture"] = "wh2_dlc11_cst_vampire_coast",
			["rite_name"] = "wh2_dlc11_ritual_cst_bountiful_treasure",
			["event_name"] = "GarrisonOccupiedEvent",
			["condition"] =
				function(context, faction_name)
					local faction = context:character():faction();
					local num_buildings = 0;
					
					if faction:name() == faction_name then
						local region_list = faction:region_list();
						
						for i = 0, region_list:num_items() - 1 do
							local current_region = region_list:item_at(i);
							
							if current_region:building_exists("wh2_dlc11_vampirecoast_infrastructure_income_other_1")
							or current_region:building_exists("wh2_dlc11_vampirecoast_infrastructure_income_other_2")
							or current_region:building_exists("wh2_dlc11_vampirecoast_infrastructure_income_other_3")
							or current_region:building_exists("wh2_dlc11_vampirecoast_infrastructure_income_other_4")
							or current_region:building_exists("wh2_dlc11_vampirecoast_infrastructure_income_other_5")
							then
								num_buildings = num_buildings + 1;
							end;
						end;
					end;
					
					return num_buildings > 2;
				end,
			["show_unlock_message"] = true
		},
		-------------------
		-- queens cannon --
		-------------------
		{
			["culture"] = "wh2_dlc11_cst_vampire_coast",
			["rite_name"] = "wh2_dlc11_ritual_cst_queens_cannon",
			["event_name"] = "CharacterRankUp",
			["condition"] =
				function(context, faction_name)
					local character = context:character();
					
					return character:faction():name() == faction_name and character:is_faction_leader() and character:rank() >= 12;
				end,
			["show_unlock_message"] = true
		},
		---------------------
		-- eternal service --
		---------------------
		{
			["culture"] = "wh2_dlc11_cst_vampire_coast",
			["rite_name"] = "wh2_dlc11_ritual_cst_eternal_service",
			["event_name"] = "GarrisonOccupiedEvent",
			["condition"] =
				function(context, faction_name)
					local faction = context:character():faction();
					
					return faction:name() == faction_name and faction:region_list():num_items() >= 3;
				end,
			["show_unlock_message"] = true
		},
		--------------
		-- sea mist --
		--------------
		{
			["culture"] = "wh2_dlc11_cst_vampire_coast",
			["rite_name"] = "wh2_dlc11_ritual_cst_sea_mist",
			["event_name"] = "MissionSucceeded",
			["condition"] =
				function(context, faction_name)
					local mission_key = context:mission():mission_record_key();
					
					if mission_key:find("wh2_dlc11_cst_treasure_map_") then
						return true;
					end;
				end,
			["show_unlock_message"] = true
		},
		------------------
		-- revitalizing --
		------------------
		{
			["culture"] = "wh2_main_skv_skaven",
			["rite_name"] = "wh2_dlc14_rituals_skv_revitalizing",
			["event_name"] = "ResearchCompleted",
			["condition"] =
				function(context, faction_name)
					if context:faction():name() == faction_name then
						local tech_count = cm:get_saved_value("rite_revitalizing_tech_count_" .. faction_name) or 0;
						
						tech_count = tech_count + 1;
						
						cm:set_saved_value("rite_revitalizing_tech_count_" .. faction_name, tech_count);
						
						return tech_count >= 5;
					end;
				end,
			["show_unlock_message"] = true
		},
		-----------------
		-- sudden kill --
		-----------------
		{
			["culture"] = "wh2_main_skv_skaven",
			["rite_name"] = "wh2_dlc14_ritual_eshin_sudden_kill",
			["event_name"] = "CharacterCompletedBattle",
			["condition"] =
				function(context, faction_name)
					local character = context:character();
					
					return character:faction():name() == faction_name and character:battles_won() >= 3;
				end,
			["show_unlock_message"] = true
		},
		
		-----------------------
		-- sacrifices unlock --
		-----------------------
		{
			["culture"] = "wh2_main_lzd_lizardmen",
			["rite_name"] = "wh2_dlc12_tehenhauin_sacrifice_of_quetza",
			["event_name"] = "ScriptEventSacrificeTier2Unlocked",
			["condition"] =
				function(context)
					local faction_key = context:faction():name();
					return faction_key == "wh2_dlc12_lzd_cult_of_sotek";
				end,
			["show_unlock_message"] = false
		},
		{
			["culture"] = "wh2_main_lzd_lizardmen",
			["rite_name"] = "wh2_dlc12_tehenhauin_sacrifice_of_huanabic",
			["event_name"] = "ScriptEventSacrificeTier2Unlocked",
			["condition"] =
				function(context)
					local faction_key = context:faction():name();
					return faction_key == "wh2_dlc12_lzd_cult_of_sotek";
				end,
			["show_unlock_message"] = false
		},
		{
			["culture"] = "wh2_main_lzd_lizardmen",
			["rite_name"] = "wh2_dlc12_tehenhauin_sacrifice_of_gwangee",
			["event_name"] = "ScriptEventSacrificeTier2Unlocked",
			["condition"] =
				function(context)
					local faction_key = context:faction():name();
					return faction_key == "wh2_dlc12_lzd_cult_of_sotek";
				end,
			["show_unlock_message"] = false
		},
		{
			["culture"] = "wh2_main_lzd_lizardmen",
			["rite_name"] = "wh2_dlc12_tehenhauin_sacrifice_of_chaqua",
			["event_name"] = "ScriptEventSacrificeTier3Unlocked",
			["condition"] =
				function(context)
					local faction_key = context:faction():name();
					return faction_key == "wh2_dlc12_lzd_cult_of_sotek";
				end,
			["show_unlock_message"] = false
		},
		{
			["culture"] = "wh2_main_lzd_lizardmen",
			["rite_name"] = "wh2_dlc12_tehenhauin_sacrifice_of_pokhopak",
			["event_name"] = "ScriptEventSacrificeTier2Unlocked",
			["condition"] =
				function(context)
					local faction_key = context:faction():name();
					return faction_key == "wh2_dlc12_lzd_cult_of_sotek";
				end,
			["show_unlock_message"] = false
		},
		{
			["culture"] = "wh2_main_lzd_lizardmen",
			["rite_name"] = "wh2_dlc12_tehenhauin_sacrifice_of_quittax",
			["event_name"] = "ScriptEventSacrificeTier3Unlocked",
			["condition"] =
				function(context)
					local faction_key = context:faction():name();
					return faction_key == "wh2_dlc12_lzd_cult_of_sotek";
				end,
			["show_unlock_message"] = false
		},
		{
			["culture"] = "wh2_main_lzd_lizardmen",
			["rite_name"] = "wh2_dlc12_tehenhauin_sacrifice_of_chiquibol",
			["event_name"] = "ScriptEventSacrificeTier3Unlocked",
			["condition"] =
				function(context)
					local faction_key = context:faction():name();
					return faction_key == "wh2_dlc12_lzd_cult_of_sotek";
				end,
			["show_unlock_message"] = false
		},
		{
			["culture"] = "wh2_main_lzd_lizardmen",
			["rite_name"] = "wh2_dlc12_tehenhauin_sacrifice_of_incatol",
			["event_name"] = "ScriptEventSacrificeTier2Unlocked",
			["condition"] =
				function(context)
					local faction_key = context:faction():name();
					return faction_key == "wh2_dlc12_lzd_cult_of_sotek";
				end,
			["show_unlock_message"] = false
		},
		{
			["culture"] = "wh2_main_lzd_lizardmen",
			["rite_name"] = "wh2_dlc12_tehenhauin_sacrifice_of_oyxl",
			["event_name"] = "ScriptEventSacrificeTier3Unlocked",
			["condition"] =
				function(context)
					local faction_key = context:faction():name();
					return faction_key == "wh2_dlc12_lzd_cult_of_sotek";
				end,
			["show_unlock_message"] = false
		},
		{
			["culture"] = "wh2_main_lzd_lizardmen",
			["rite_name"] = "wh2_dlc12_tehenhauin_sacrifice_of_aymara",
			["event_name"] = "ScriptEventSacrificeTier4Unlocked",
			["condition"] =
				function(context)
					local faction_key = context:faction():name();
					return faction_key == "wh2_dlc12_lzd_cult_of_sotek";
				end,
			["show_unlock_message"] = false
		},
		{
			["culture"] = "wh2_main_lzd_lizardmen",
			["rite_name"] = "wh2_dlc12_tehenhauin_sacrifice_of_axlotl",
			["event_name"] = "ScriptEventSacrificeTier4Unlocked",
			["condition"] =
				function(context)
					local faction_key = context:faction():name();
					return faction_key == "wh2_dlc12_lzd_cult_of_sotek";
				end,
			["show_unlock_message"] = false
		},
		{
			["culture"] = "wh2_main_lzd_lizardmen",
			["rite_name"] = "wh2_dlc12_tehenhauin_sacrifice_of_xlaxgor",
			["event_name"] = "ScriptEventSacrificeTier4Unlocked",
			["condition"] =
				function(context)
					local faction_key = context:faction():name();
					return faction_key == "wh2_dlc12_lzd_cult_of_sotek";
				end,
			["show_unlock_message"] = false
		},
		{
			["culture"] = "wh2_main_lzd_lizardmen",
			["rite_name"] = "wh2_dlc12_tehenhauin_sacrifice_of_capac",
			["event_name"] = "ScriptEventSacrificeTier5Unlocked",
			["condition"] =
				function(context)
					local faction_key = context:faction():name();
					return faction_key == "wh2_dlc12_lzd_cult_of_sotek";
				end,
			["show_unlock_message"] = false
		},
		{
			["culture"] = "wh2_main_lzd_lizardmen",
			["rite_name"] = "wh2_dlc12_tehenhauin_sacrifice_of_malliente",
			["event_name"] = "ScriptEventSacrificeTier5Unlocked",
			["condition"] =
				function(context)
					local faction_key = context:faction():name();
					return faction_key == "wh2_dlc12_lzd_cult_of_sotek";
				end,
			["show_unlock_message"] = false
		},
		{
			["culture"] = "wh2_main_lzd_lizardmen",
			["rite_name"] = "wh2_dlc12_tehenhauin_sacrifice_of_sotek",
			["event_name"] = "ScriptEventSacrificeTier5Unlocked",
			["condition"] =
				function(context)
					local faction_key = context:faction():name();
					return faction_key == "wh2_dlc12_lzd_cult_of_sotek";
				end,
			["show_unlock_message"] = false
		}
	};
	
	local human_factions = cm:get_human_factions();
	
	for i = 1, #human_factions do
		local current_faction = cm:get_faction(human_factions[i])
		for j = 1, #rite_templates do
			local current_rite_template = rite_templates[j];
			if current_faction:culture() == current_rite_template.culture and not current_faction:rituals():ritual_status(current_rite_template.rite_name):disabled() then
				cm:lock_ritual(current_faction, current_rite_template.rite_name)
				local rite = rite_unlock:new(
					current_rite_template.rite_name,
					current_rite_template.event_name,
					current_rite_template.condition,
					current_rite_template.show_unlock_message
				)
				
				rite:start(human_factions[i]);
			end;
		end;
	end;
end;

function rite_unlock:new(rite_key, event, condition, show_unlock_message)
	if not is_string(rite_key) then
		script_error("ERROR: rite_unlock:new() called but supplied rite_key [" .. tostring(rite_key) .."] is not a string");
		return false;
	end;
	
	if not is_string(event) then
		script_error("ERROR: rite_unlock:new() called but supplied event [" .. tostring(event) .."] is not a string");
		return false;
	end;
	
	if not is_function(condition) then
		script_error("ERROR: rite_unlock:new() called but supplied condition [" .. tostring(condition) .."] is not a function");
		return false;
	end;
	
	local cm = get_cm();
	
	local rite = {};
	setmetatable(rite, self);
	self.__index = self;
	
	rite.cm = cm;
	rite.rite_key = rite_key;
	rite.event = event;
	rite.condition = condition;
	rite.show_unlock_message = not not show_unlock_message;
	
	return rite;
end;

function rite_unlock:start(human_faction_name)
	local cm = self.cm;
	
	if common.tweaker_value("UNLOCK_MINOR_RITUALS") ~= "0" then
		unlock_rite(human_faction_name, self.rite_key);
	elseif cm:get_saved_value(self.rite_key .. "_" .. human_faction_name .. "_unlocked") then
		out.design("Rites -- Not starting listener for rite with key [" .. self.rite_key .. "] for faction [" .. human_faction_name .. "] as they have already been unlocked");
		unlock_rite(human_faction_name, self.rite_key);
		return false;
	else
		out.design("Rites -- Starting listener for rite with key [" .. self.rite_key .. "] for faction [" .. human_faction_name .. "]");
		
		core:add_listener(
			self.rite_key .. "_" .. human_faction_name .. "_listener",
			self.event,
			function(context)
				return self.condition(context, human_faction_name);
			end,
			function()
				out.design("Rites -- Conditions met for event [" .. self.event .. "], unlocking rite with key [" .. self.rite_key .. "] for faction [" .. human_faction_name .. "]");
				
				core:trigger_event("ScriptEventRiteUnlocked", cm:get_faction(human_faction_name), self.rite_key);
				
				unlock_rite(human_faction_name, self.rite_key);
				
				if self.show_unlock_message then
					show_rite_unlocked_event(human_faction_name, self.rite_key);
				end;
				
				cm:set_saved_value(self.rite_key .. "_" .. human_faction_name .. "_unlocked", true);
				core:remove_listener(self.rite_key .. "_" .. human_faction_name .. "_listener");
			end,
			false
		);
	end;
end;

function unlock_rite(faction_name, rite_key)
	cm:unlock_ritual(cm:get_faction(faction_name), rite_key);
end;

function show_rite_unlocked_event(faction_name, rite_key)
	local id = 810;
	
	local culture = cm:get_faction(faction_name):culture();
	
	if culture == "wh2_main_def_dark_elves" then
		id = 811;
	elseif culture == "wh2_main_lzd_lizardmen" then
		id = 812;
	elseif culture == "wh2_main_skv_skaven" then
		id = 813;
	elseif culture == "wh2_dlc09_tmb_tomb_kings" then
		id = 902;	
	elseif culture == "wh2_dlc11_cst_vampire_coast" then
		id = 904;	
	end;
	
	-- delay the event in case the act of unlocking the rite has its own relevant events e.g. mission succeeded
	cm:callback(
		function()
			cm:show_message_event(
				faction_name,
				"event_feed_strings_text_wh2_event_feed_string_scripted_event_rite_unlocked_primary_detail",
				"rituals_display_name_" .. rite_key,
				"event_feed_strings_text_wh2_event_feed_string_scripted_event_rite_unlocked_secondary_detail_" .. rite_key,
				true,
				id,
				nil,
				nil,
				true
			);
		end,
		0.2
	);
end;




core:add_listener(
	"rite_events",
	"RitualCompletedEvent",
	function(context)
		return context:ritual():ritual_category() == "STANDARD_RITUAL";
	end,
	function(context)
		local ritual = context:ritual();
		local ritual_key = ritual:ritual_key();
		local faction = context:performing_faction();
		local faction_name = faction:name();
		
		if ritual_key == "wh2_main_ritual_hef_vaul" or ritual_key == "wh2_dlc15_ritual_hef_vaul_greater" then
			trigger_ritual_of_vaul_dilemma(faction);
		elseif ritual_key == "wh2_main_ritual_skv_pestilence" or ritual_key == "wh2_dlc14_ritual_skv_pestilence_pestilens" then
			rite_agent_spawn(faction_name,"wizard","wh2_main_skv_plague_priest_ritual")
			trigger_skaven_hero_vfx(faction);
		elseif ritual_key == "wh2_main_ritual_skv_doooom" then
			rite_agent_spawn(faction_name,"engineer","wh2_main_skv_warlock_engineer_ritual")
			trigger_skaven_hero_vfx(faction);
		elseif ritual_key == "wh2_dlc10_ritual_hef_morai_heg" then
			rite_agent_spawn(faction_name,"spy","wh2_dlc10_hef_shadow_walker")
		elseif ritual_key == "wh2_dlc09_ritual_tmb_ptra" then
			rite_agent_spawn(faction_name,"engineer","wh2_dlc09_tmb_necrotect_ritual")
		elseif ritual_key == "wh2_dlc11_ritual_cst_bountiful_treasure" then
			trigger_bountiful_treasure_treasury(faction);
		elseif ritual_key == "wh2_dlc12_lzd_tiktaqto_ritual_persistence" then
			trigger_tiktaqto_rite(faction);
		end;
		
		local is_human = faction:is_human();
		
		if not is_human and (ritual_key == "wh2_main_ritual_def_mathlann" or ritual_key == "wh2_main_ritual_lzd_primeval_glory" or ritual_key == "wh2_main_ritual_lzd_sotek" or ritual_key == "wh2_main_ritual_lzd_awakening" or ritual_key == "wh2_main_ritual_skv_pestilence" or ritual_key == "wh2_main_ritual_skv_doooom" or ritual_key == "wh2_dlc09_ritual_tmb_khsar") then
			show_ai_rite_performed_event(faction, ritual_key);
		elseif is_human then
			local cooldown_time = ritual:cooldown_time();
			
			if cooldown_time > 0 and ritual_key ~= "wh2_twa03_ritual_def_beasthunt" then --ignore Rakarth's Beast Hunt as it's a special case with a variable cooldown
				cm:add_turn_countdown_event(faction_name, cooldown_time, "ScriptEventRiteExpired", faction_name .. "," .. ritual_key);
			end;
			
			-- global cooldown - ensure time matches db value
			cm:add_turn_countdown_event(faction_name, 5, "ScriptEventRiteGlobalCooldownExpired", faction_name);
			
			cm:set_saved_value("global_cooldown_expired", false);
		end;
	end,
	true
);

core:add_listener(
	"rite_expired",
	"ScriptEventRiteExpired",
	true,
	function(context)
		-- there's no global cooldown active, show the event
		if cm:get_saved_value("global_cooldown_expired") then
			show_rite_expired_event(context.string);
		-- the global cooldown is still active, wait until it finishes before showing the event
		else
			core:add_listener(
				"rite_expired_after_global_cooldown_expired",
				"ScriptEventRiteGlobalCooldownExpired",
				true,
				function()
					show_rite_expired_event(context.string);
				end,
				false
			);
		end;
	end,
	true
);

core:add_listener(
	"global_rite_cooldown_expired",
	"ScriptEventRiteGlobalCooldownExpired",
	true,
	function()
		cm:set_saved_value("global_cooldown_expired", true);
	end,
	true
);

-- rite of vaul triggers a dilemma for player, gives AI the item instantly
function trigger_ritual_of_vaul_dilemma(faction)
	-- trigger a dilemma if the faction is human
	if faction:is_human() then
		local dilemma_list = {
			"wh2_main_dilemma_ritual_of_vaul_1",
			"wh2_main_dilemma_ritual_of_vaul_2",
			"wh2_main_dilemma_ritual_of_vaul_3",
			"wh2_main_dilemma_ritual_of_vaul_4",
			"wh2_main_dilemma_ritual_of_vaul_5"
		};
		
		local index = cm:random_number(#dilemma_list);
		
		cm:trigger_dilemma(faction:name(), dilemma_list[index]);
	-- award the item directly if the faction is AI (to the faction leader)
	else
		local item_list = {
			"wh2_main_anc_weapon_reaver_bow",
			"wh2_main_anc_arcane_item_jewel_of_the_dusk",
			"wh2_main_anc_armour_crown_of_authority",
			"wh2_main_anc_talisman_amulet_of_foresight",
			"wh2_main_anc_weapon_winged_staff",
			"wh2_main_anc_armour_helm_of_khaine",
			"wh2_main_anc_enchanted_item_enchanted_spyglass",
			"wh2_main_anc_talisman_ruby_guardian_phoenix",
			"wh2_main_anc_weapon_blade_of_sea_gold",
			"wh2_main_anc_enchanted_item_blessed_tome",
			"wh2_main_anc_arcane_item_staff_of_solidity",
			"wh2_main_anc_talisman_sapphire_guardian_phoenix",
			"wh2_main_anc_enchanted_item_chest_of_sustenance",
			"wh2_main_anc_armour_winged_boots",
			"wh2_main_anc_enchanted_item_gilded_horn_of_galon_konook",
			"wh2_main_anc_talisman_diamond_guardian_phoenix",
			"wh2_main_anc_enchanted_item_ring_of_hukon",
			"wh2_main_anc_weapon_sea_gold_parrying_blade",
			"wh2_main_anc_talisman_emerald_collar",
			"wh2_main_anc_armour_enchanted_ithilmar_breastplate"
		};
		
		local index = cm:random_number(#item_list);
		cm:force_add_ancillary(faction:faction_leader(), item_list[index], false, false);
	end;	
end;

function trigger_skaven_hero_vfx(faction)
	local character_list = faction:character_list();
	
	for i = 0, character_list:num_items() - 1 do
		local current_char = character_list:item_at(i);
		local current_char_subtype = current_char:character_subtype_key();
		
		if current_char_subtype:find("_ritual") then
			local show_in_shroud = false;
			cm:add_character_vfx(current_char:cqi(), "scripted_effect", show_in_shroud);
		end;
	end;
end;

function trigger_bountiful_treasure_treasury(faction)
	local region_list = faction:region_list();
	local faction_name = faction:name();
	local treasury_to_add = 0;
	
	for i = 0, region_list:num_items() - 1 do
		local current_region = region_list:item_at(i);
		
		if current_region:building_exists("wh2_dlc11_vampirecoast_infrastructure_income_other_1")
		or current_region:building_exists("wh2_dlc11_vampirecoast_infrastructure_income_other_2")
		or current_region:building_exists("wh2_dlc11_vampirecoast_infrastructure_income_other_3")
		or current_region:building_exists("wh2_dlc11_vampirecoast_infrastructure_income_other_4")
		or current_region:building_exists("wh2_dlc11_vampirecoast_infrastructure_income_other_5") then
			treasury_to_add = treasury_to_add + 500;
		end;
	end;
	
	if treasury_to_add > 0 then
		cm:treasury_mod(faction_name, treasury_to_add);
	end;
end;

function trigger_tiktaqto_rite(faction)
	local character_list = faction:character_list();
	for i = 0, character_list:num_items()- 1 do
		if character_list:item_at(i):faction():name() == faction:name() then
			cm:replenish_action_points(cm:char_lookup_str(character_list:item_at(i)));
			out.design("character_cqi"..tostring(character_list:item_at(i):cqi()));
			out.design("character_name"..tostring(character_list:item_at(i):get_forename()));
		end
		
	end;
end;

function show_ai_rite_performed_event(faction, rite_key)
	if faction:has_home_region() then
		local capital = faction:home_region():settlement();
		local factions_known = faction:factions_met();
		local culture = faction:culture();
		local id = 820;
		
		if culture == "wh2_main_def_dark_elves" then
			id = 821;
		elseif culture == "wh2_main_lzd_lizardmen" then
			id = 822;
		elseif culture == "wh2_main_skv_skaven" then
			id = 823;
		elseif culture == "wh2_dlc09_tmb_tomb_kings" then
			id = 824;
		elseif culture == "wh2_dlc11_cst_vampire_coast" then
			id = 825;	
		end;
		
		for i = 0, factions_known:num_items() - 1 do
			local current_faction = factions_known:item_at(i);
			
			if current_faction:is_human() then
				local current_faction_name = current_faction:name();
				local primary_detail = "event_feed_strings_text_wh2_event_feed_string_scripted_event_ai_rite_performed_primary_detail_" .. rite_key;
				local ai_faction_name = "factions_screen_name_" .. faction:name()
				local secondary_detail = "event_feed_strings_text_wh2_event_feed_string_scripted_event_ai_rite_performed_secondary_detail_" .. rite_key;
				
				if culture == "wh2_main_skv_skaven" then
					cm:show_message_event(
						current_faction_name,
						primary_detail,
						ai_faction_name,
						secondary_detail,
						true,
						id
					);
				else
					cm:show_message_event_located(
						current_faction_name,
						primary_detail,
						ai_faction_name,
						secondary_detail,
						capital:logical_position_x(),
						capital:logical_position_y(),
						true,
						id
					);
				end;
			end;
		end;
	end;
end;

function show_rite_expired_event(context_str)
	local separator_pos = string.find(context_str, ",");
	
	if not separator_pos then
		script_error("show_rite_expired_event() called but context_str " .. tostring(context_str) .. " could not be separated into faction and rite key");
		return;
	end;
	
	local faction_name = string.sub(context_str, 1, separator_pos - 1);
	local rite_key = string.sub(context_str, separator_pos + 1);
	
	local culture = cm:get_faction(faction_name):culture();
	local id = 890;
	
	if culture == "wh2_main_def_dark_elves" then
		id = 891;
	elseif culture == "wh2_main_lzd_lizardmen" then
		id = 892;
	elseif culture == "wh2_main_skv_skaven" then
		id = 893;
	elseif culture == "wh2_dlc09_tmb_tomb_kings" then
		id = 903;	
	elseif culture == "wh2_dlc11_cst_vampire_coast" then
		id = 907;		
	end;
	
	cm:show_message_event(
		faction_name,
		"event_feed_strings_text_wh2_event_feed_string_scripted_event_rite_expired_primary_detail",
		"rituals_display_name_" .. rite_key,
		"event_feed_strings_text_wh2_event_feed_string_scripted_event_rite_expired_secondary_detail",
		true,
		id
	);
end;

function rite_agent_spawn(faction_key, type_key, subtype_key)
	local faction = cm:get_faction(faction_key); 
	local mf_list = faction:military_force_list();
	local target = nil;
	
	if faction:has_faction_leader() then
		local faction_leader = faction:faction_leader();
		if faction_leader:has_military_force() then
			target = faction_leader:military_force();
		end
	end
	
	-- if faction leader isn't available then find a different force
	if not target then
		for _, force in model_pairs(mf_list) do
			if not force:is_armed_citizenry() and not (force:has_garrison_residence() and force:garrison_residence():is_under_siege()) then
				target = force;
				break;
			end
		end
	end
	
	-- if there are still no suitable characters to spawn at, then spawn at region instead
	if not target then
		for _, region in model_pairs(faction:region_list()) do
			if not region:garrison_residence():is_under_siege() then
				target = region:settlement();
				break;
			end
		end
	end
	
	if target then
		rite_character_spawned = true;
		
		-- set up a listener to replenish the character's AP after they spawn 
		core:add_listener(
			"RiteCharacterCreated",
			"CharacterCreated",
			function(context)
				return context:character():faction():name() == faction_key and rite_character_spawned;
			end,
			function(context)
				local character = context:character();
				cm:callback( -- we need to wait a tick for this to work, for some reason
					function()
						cm:replenish_action_points(cm:char_lookup_str(character));
						
						if cm:get_local_faction(true) == faction_key then
							cm:scroll_camera_from_current(false, 1, {character:display_position_x(), character:display_position_y(), 14.7, 0.0, 12.0});
						end;
					end,
					0.2
				)
				rite_character_spawned = false;
			end,
			false
		)
		
		if is_militaryforce(target) then
			cm:spawn_agent_at_military_force(faction, target, type_key, subtype_key);
		else
			cm:spawn_agent_at_settlement(faction, target, type_key, subtype_key);
		end
	end
end