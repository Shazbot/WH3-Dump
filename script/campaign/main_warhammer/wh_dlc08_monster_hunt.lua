local monster_hunts_index = {
	"monster_hunt_0",
	"monster_hunt_1",
	"monster_hunt_2",
	"monster_hunt_3",
	"monster_hunt_4",
	"monster_hunt_5",
	"monster_hunt_6",
	"monster_hunt_7",
	"monster_hunt_8",
	"monster_hunt_9",
	"monster_hunt_10",
	"monster_hunt_11"
};

local monster_hunts_other_faction = {
	["wh_dlc08_nor_norsca"] = "wh_dlc08_nor_wintertooth",
	["wh_dlc08_nor_wintertooth"] = "wh_dlc08_nor_norsca"
};

local monster_hunts_ror_index = {
	["monster_hunt_0"] = "wh_dlc08_nor_mon_frost_wyrm_ror_0",
	["monster_hunt_6"] = "wh_dlc08_nor_mon_war_mammoth_ror_1"
};

local monster_hunts = {
	["wh_dlc08_nor_norsca"] = {
		["monster_hunt_0"] = {
				["mission"] = "wh_dlc08_monster_hunt_0_stage_1",
				["mpc_mission"] = "wh_dlc08_monster_hunt_0_stage_4_mpc",
				["qb"] = "wh_dlc08_qb_nor_monster_hunt_0",
				["fin"] = "wh_dlc08_nor_monster_hunt_0_dilemma_reward",
				["state"] = "active",
				["reward"] = "wh_dlc08_anc_enchanted_item_ancient_frost_wyrm_scale",
				["tech"] = "wh_dlc08_tech_nor_creatures_01"
		},
		["monster_hunt_1"] = {
				["mission"] = "wh_dlc08_monster_hunt_1_stage_1",
				["mpc_mission"] = "wh_dlc08_monster_hunt_1_stage_5_mpc",
				["qb"] = "wh_dlc08_qb_nor_monster_hunt_1",
				["fin"] = "wh_dlc08_nor_monster_hunt_1_dilemma_reward",
				["state"] = "active",
				["reward"] = "wh_dlc08_anc_talisman_giant_cygor_eyeball",
				["tech"] = "wh_dlc08_tech_nor_creatures_01"
		},
		["monster_hunt_2"] = {
				["mission"] = "wh_dlc08_monster_hunt_2_stage_1",
				["mpc_mission"] = "wh_dlc08_monster_hunt_2_stage_4_mpc",
				["qb"] = "wh_dlc08_qb_nor_monster_hunt_2",
				["fin"] = "wh_dlc08_nor_monster_hunt_2_dilemma_reward",
				["state"] = "active",
				["reward"] = "wh_dlc08_anc_enchanted_item_great_horn_of_dragon_ogre",
				["tech"] = "wh_dlc08_tech_nor_creatures_01"
		},
		["monster_hunt_3"] = {
				["mission"] = "wh_dlc08_monster_hunt_3_stage_1",
				["mpc_mission"] = "wh_dlc08_monster_hunt_3_stage_3_mpc",
				["qb"] = "wh_dlc08_qb_nor_monster_hunt_3",
				["fin"] = "wh_dlc08_nor_monster_hunt_3_dilemma_reward",
				["state"] = "active",
				["reward"] = "wh_dlc08_anc_enchanted_item_arachnarok_eggs",
				["tech"] = "wh_dlc08_tech_nor_creatures_06"
		},
		["monster_hunt_4"] = {
				["mission"] = "wh_dlc08_monster_hunt_4_stage_1",
				["mpc_mission"] = "wh_dlc08_monster_hunt_4_stage_3_2_mpc",
				["qb"] = "wh_dlc08_qb_nor_monster_hunt_4",
				["fin"] = "wh_dlc08_nor_monster_hunt_4_dilemma_reward",
				["state"] = "active",
				["reward"] = "wh_dlc08_anc_weapon_stinky_giant_club",
				["tech"] = "wh_dlc08_tech_nor_creatures_06"
		},
		["monster_hunt_5"] = {
				["mission"] = "wh_dlc08_monster_hunt_5_stage_1",
				["mpc_mission"] = "wh_dlc08_monster_hunt_5_stage_3_mpc",
				["qb"] = "wh_dlc08_qb_nor_monster_hunt_5",
				["fin"] = "wh_dlc08_nor_monster_hunt_5_dilemma_reward",
				["state"] = "active",
				["reward"] = "wh_dlc08_anc_weapon_forest_dragon_fang",
				["tech"] = "wh_dlc08_tech_nor_creatures_06"
		},
		["monster_hunt_6"] = {
				["mission"] = "wh_dlc08_monster_hunt_6_stage_1",
				["mpc_mission"] = "wh_dlc08_monster_hunt_6_stage_3_mpc",
				["qb"] = "wh_dlc08_qb_nor_monster_hunt_6",
				["fin"] = "wh_dlc08_nor_monster_hunt_6_dilemma_reward",
				["state"] = "active",
				["reward"] = "wh_dlc08_anc_magic_standard_ancient_mammoth_cub",
				["tech"] = "wh_dlc08_tech_nor_creatures_07"
		},
		["monster_hunt_7"] = {
				["mission"] = "wh_dlc08_monster_hunt_7_stage_1",
				["mpc_mission"] = "wh_dlc08_monster_hunt_7_stage_3_mpc",
				["qb"] = "wh_dlc08_qb_nor_monster_hunt_7",
				["fin"] = "wh_dlc08_nor_monster_hunt_7_dilemma_reward",
				["state"] = "active",
				["reward"] = "wh_dlc08_anc_talisman_terrorgheist_skull",
				["tech"] = "wh_dlc08_tech_nor_creatures_07"
		},
		["monster_hunt_8"] = {
				["mission"] = "wh2_dlc10_monster_hunt_8_stage_1",
				["mpc_mission"] = "wh2_dlc10_monster_hunt_8_stage_4_mpc",
				["qb"] = "wh2_dlc10_qb_nor_monster_hunt_8",
				["fin"] = "wh2_dlc10_nor_monster_hunt_8_dilemma_reward",
				["state"] = "active",
				["reward"] = "wh2_dlc10_anc_enchanted_item_burning_phoenix_pinion",
				["tech"] = "wh_dlc08_tech_nor_creatures_07"
		},
		["monster_hunt_9"] = {
				["mission"] = "wh2_dlc10_monster_hunt_9_stage_1",
				["mpc_mission"] = "wh2_dlc10_monster_hunt_9_stage_4_mpc",
				["qb"] = "wh2_dlc10_qb_nor_monster_hunt_9",
				["fin"] = "wh2_dlc10_nor_monster_hunt_9_dilemma_reward",
				["state"] = "active",
				["reward"] = "wh2_dlc10_anc_talisman_carnosaur_skull",
				["tech"] = "wh_dlc08_tech_nor_creatures_07"
		},
		["monster_hunt_10"] = {
				["mission"] = "wh2_dlc10_monster_hunt_10_stage_1",
				["mpc_mission"] = "wh2_dlc10_monster_hunt_10_stage_4_mpc",
				["qb"] = "wh2_dlc10_qb_nor_monster_hunt_10",
				["fin"] = "wh2_dlc10_nor_monster_hunt_10_dilemma_reward",
				["state"] = "active",
				["reward"] = "wh2_dlc10_anc_talisman_hydra_head",
				["tech"] = "wh_dlc08_tech_nor_creatures_07"
		},
		["monster_hunt_11"] = {
				["mission"] = "wh2_dlc10_monster_hunt_11_stage_1",
				["mpc_mission"] = "wh2_dlc10_monster_hunt_11_stage_3_mpc",
				["qb"] = "wh2_dlc10_qb_nor_monster_hunt_11",
				["fin"] = "wh2_dlc10_nor_monster_hunt_11_dilemma_reward",
				["state"] = "active",
				["reward"] = "wh2_dlc10_anc_weapon_warptech_arsenal",
				["tech"] = "wh_dlc08_tech_nor_creatures_07"
		}
	},
	["wh_dlc08_nor_wintertooth"] = {
		["monster_hunt_0"] = {
				["mission"] = "wh_dlc08_monster_hunt_0_stage_1",
				["mpc_mission"] = "wh_dlc08_monster_hunt_0_stage_4_mpc",
				["qb"] = "wh_dlc08_qb_nor_monster_hunt_0",
				["fin"] = "wh_dlc08_nor_monster_hunt_0_dilemma_reward",
				["state"] = "active",
				["reward"] = "wh_dlc08_anc_enchanted_item_ancient_frost_wyrm_scale",
				["tech"] = "wh_dlc08_tech_nor_creatures_01"
		},
		["monster_hunt_1"] = {
				["mission"] = "wh_dlc08_monster_hunt_1_stage_1",
				["mpc_mission"] = "wh_dlc08_monster_hunt_1_stage_5_mpc",
				["qb"] = "wh_dlc08_qb_nor_monster_hunt_1",
				["fin"] = "wh_dlc08_nor_monster_hunt_1_dilemma_reward",
				["state"] = "active",
				["reward"] = "wh_dlc08_anc_talisman_giant_cygor_eyeball",
				["tech"] = "wh_dlc08_tech_nor_creatures_01"
		},
		["monster_hunt_2"] = {
				["mission"] = "wh_dlc08_monster_hunt_2_stage_1",
				["mpc_mission"] = "wh_dlc08_monster_hunt_2_stage_4_mpc",
				["qb"] = "wh_dlc08_qb_nor_monster_hunt_2",
				["fin"] = "wh_dlc08_nor_monster_hunt_2_dilemma_reward",
				["state"] = "active",
				["reward"] = "wh_dlc08_anc_enchanted_item_great_horn_of_dragon_ogre",
				["tech"] = "wh_dlc08_tech_nor_creatures_01"
		},
		["monster_hunt_3"] = {
				["mission"] = "wh_dlc08_monster_hunt_3_stage_1",
				["mpc_mission"] = "wh_dlc08_monster_hunt_3_stage_3_mpc",
				["qb"] = "wh_dlc08_qb_nor_monster_hunt_3",
				["fin"] = "wh_dlc08_nor_monster_hunt_3_dilemma_reward",
				["state"] = "active",
				["reward"] = "wh_dlc08_anc_enchanted_item_arachnarok_eggs",
				["tech"] = "wh_dlc08_tech_nor_creatures_06"
		},
		["monster_hunt_4"] = {
				["mission"] = "wh_dlc08_monster_hunt_4_stage_1",
				["mpc_mission"] = "wh_dlc08_monster_hunt_4_stage_3_2_mpc",
				["qb"] = "wh_dlc08_qb_nor_monster_hunt_4",
				["fin"] = "wh_dlc08_nor_monster_hunt_4_dilemma_reward",
				["state"] = "active",
				["reward"] = "wh_dlc08_anc_weapon_stinky_giant_club",
				["tech"] = "wh_dlc08_tech_nor_creatures_06"
		},
		["monster_hunt_5"] = {
				["mission"] = "wh_dlc08_monster_hunt_5_stage_1",
				["mpc_mission"] = "wh_dlc08_monster_hunt_5_stage_3_mpc",
				["qb"] = "wh_dlc08_qb_nor_monster_hunt_5",
				["fin"] = "wh_dlc08_nor_monster_hunt_5_dilemma_reward",
				["state"] = "active",
				["reward"] = "wh_dlc08_anc_weapon_forest_dragon_fang",
				["tech"] = "wh_dlc08_tech_nor_creatures_06"
		},
		["monster_hunt_6"] = {
				["mission"] = "wh_dlc08_monster_hunt_6_stage_1",
				["mpc_mission"] = "wh_dlc08_monster_hunt_6_stage_3_mpc",
				["qb"] = "wh_dlc08_qb_nor_monster_hunt_6",
				["fin"] = "wh_dlc08_nor_monster_hunt_6_dilemma_reward",
				["state"] = "active",
				["reward"] = "wh_dlc08_anc_magic_standard_ancient_mammoth_cub",
				["tech"] = "wh_dlc08_tech_nor_creatures_07"
		},
		["monster_hunt_7"] = {
				["mission"] = "wh_dlc08_monster_hunt_7_stage_1",
				["mpc_mission"] = "wh_dlc08_monster_hunt_7_stage_3_mpc",
				["qb"] = "wh_dlc08_qb_nor_monster_hunt_7",
				["fin"] = "wh_dlc08_nor_monster_hunt_7_dilemma_reward",
				["state"] = "active",
				["reward"] = "wh_dlc08_anc_talisman_terrorgheist_skull",
				["tech"] = "wh_dlc08_tech_nor_creatures_07"
		},
		["monster_hunt_8"] = {
				["mission"] = "wh2_dlc10_monster_hunt_8_stage_1",
				["mpc_mission"] = "wh2_dlc10_monster_hunt_8_stage_4_mpc",
				["qb"] = "wh2_dlc10_qb_nor_monster_hunt_8",
				["fin"] = "wh2_dlc10_nor_monster_hunt_8_dilemma_reward",
				["state"] = "active",
				["reward"] = "wh2_dlc10_anc_enchanted_item_burning_phoenix_pinion",
				["tech"] = "wh_dlc08_tech_nor_creatures_07"
		},
		["monster_hunt_9"] = {
				["mission"] = "wh2_dlc10_monster_hunt_9_stage_1",
				["mpc_mission"] = "wh2_dlc10_monster_hunt_9_stage_4_mpc",
				["qb"] = "wh2_dlc10_qb_nor_monster_hunt_9",
				["fin"] = "wh2_dlc10_nor_monster_hunt_9_dilemma_reward",
				["state"] = "active",
				["reward"] = "wh2_dlc10_anc_talisman_carnosaur_skull",
				["tech"] = "wh_dlc08_tech_nor_creatures_07"
		},
		["monster_hunt_10"] = {
				["mission"] = "wh2_dlc10_monster_hunt_10_stage_1",
				["mpc_mission"] = "wh2_dlc10_monster_hunt_10_stage_4_mpc",
				["qb"] = "wh2_dlc10_qb_nor_monster_hunt_10",
				["fin"] = "wh2_dlc10_nor_monster_hunt_10_dilemma_reward",
				["state"] = "active",
				["reward"] = "wh2_dlc10_anc_talisman_hydra_head",
				["tech"] = "wh_dlc08_tech_nor_creatures_07"
		},
		["monster_hunt_11"] = {
				["mission"] = "wh2_dlc10_monster_hunt_11_stage_1",
				["mpc_mission"] = "wh2_dlc10_monster_hunt_11_stage_3_mpc",
				["qb"] = "wh2_dlc10_qb_nor_monster_hunt_11",
				["fin"] = "wh2_dlc10_nor_monster_hunt_11_dilemma_reward",
				["state"] = "active",
				["reward"] = "wh2_dlc10_anc_weapon_warptech_arsenal",
				["tech"] = "wh_dlc08_tech_nor_creatures_07"
		}
	}
};

local monster_hunts_default = monster_hunts;

function activate_a_monster_hunt(mission_index, faction, other_faction, compo)
	if monster_hunts[faction][mission_index]["state"] == "active" then
		local monster_hunt_type = "mission";
		
		if cm:is_multiplayer() then
			if monster_hunts[faction][mission_index]["mpc_mission"] then
				monster_hunt_type = "mpc_mission";
			elseif monster_hunts[faction][mission_index]["mpc_incident"] then
				monster_hunt_type = "mpc_incident";
			elseif monster_hunts[faction][mission_index]["mpc_dilemma"] then
				monster_hunt_type = "mpc_dilemma";
			end;
		end;
		
		UIComponent(compo):InterfaceFunction("ActivateMission", monster_hunts[faction][mission_index][monster_hunt_type]);
		monster_hunts[faction][mission_index]["state"] = "in_progress";
		
		for i = 1, #monster_hunts_index do
			if monster_hunts_index[i] ~= mission_index and monster_hunts[faction][monster_hunts_index[i]]["state"] == "active" then
				monster_hunts[faction][monster_hunts_index[i]]["state"] = "inactive";
			end;
		end;
		
		Play_Norsca_Advice("dlc08.camp.advice.nor.mon_hunt.002", norsca_info_text_monsters);
	end;
end;

function deactivate_a_monster_hunt(mission_index, faction)
	if monster_hunts[faction][mission_index]["state"] == "in_progress" then
		monster_hunts[faction][mission_index]["state"] = "completed"; 
		
		for i = 1, #monster_hunts_index do
			if monster_hunts_index[i] ~= mission_index and monster_hunts[faction][monster_hunts_index[i]]["state"] == "inactive" then
				monster_hunts[faction][monster_hunts_index[i]]["state"] = "active";
			end;
		end;
		
		Play_Norsca_Advice("dlc08.camp.advice.nor.mon_hunt.003", norsca_info_text_monsters);
	end;
end;

core:add_listener(
	"MonsterHuntMissionSucceeded",
	"MissionSucceeded",
	true,
	function(context)
		local faction = context:faction():name();
		local key = context:mission():mission_record_key();
		local maxed = false;
		
		if monster_hunts_other_faction[faction] then
			for i = 1, #monster_hunts_index do
				if key == monster_hunts[faction][monster_hunts_index[i]]["qb"] then
					if not cm:get_saved_value("norscan_favour_lvl_3_reached_" .. faction) then
						cm:trigger_dilemma(faction, monster_hunts[faction][monster_hunts_index[i]]["fin"]);
					end;
					
					deactivate_a_monster_hunt(monster_hunts_index[i], faction);
					
					if key == "wh_dlc08_qb_nor_monster_hunt_6" then
						cm:remove_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_war_mammoth_ror_1", faction);
					elseif key == "wh_dlc08_qb_nor_monster_hunt_0" then
						cm:remove_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_frost_wyrm_ror_0", faction);
					end;
				end;
			end;
		end;
	end,
	true
);

core:add_listener(
    "MonsterHuntBookListener",
    "PanelOpenedCampaign",
    function(context)
		return context.string == "book_of_monster_hunts";
	end,
    function(context)
        local faction = cm:get_local_faction_name(true);
		
		for i = 1, #monster_hunts_index do
			local current_monster_hunt_data = monster_hunts_index[i];
			
			UIComponent(context.component):InterfaceFunction(
				"AddEntry",
				current_monster_hunt_data .. "_title",
				current_monster_hunt_data .. "_description",
				current_monster_hunt_data .. "_objective",
				monster_hunts[faction][current_monster_hunt_data]["reward"],
				monster_hunts[faction][current_monster_hunt_data]["tech"],
				monster_hunts[faction][current_monster_hunt_data]["state"],
				current_monster_hunt_data
			);
			
			if monster_hunts_ror_index[current_monster_hunt_data] then
				UIComponent(context.component):InterfaceFunction("AddEntryRewards", current_monster_hunt_data, "treasury:10000", "unit:"..monster_hunts_ror_index[current_monster_hunt_data])
			else
				UIComponent(context.component):InterfaceFunction("AddEntryRewards", current_monster_hunt_data, "treasury:10000");
			end;
		end;
		
		Play_Norsca_Advice("dlc08.camp.advice.nor.mon_hunt.001", norsca_info_text_monsters);
    end,
    true
);

core:add_listener(
	"AssignMonsterHuntListener",
	"ComponentLClickUp",
	function(context)
		return context.string == "button_activate";
	end,
	function(context)
		local faction = cm:get_local_faction(true)
			
		if faction:is_factions_turn() and UIComponent(context.component):Parent(false, "book_of_monster_hunts") ~= nil then
			local mission_index = UIComponent(context.component):InterfaceFunction("GetAssociatedEntry");
			local faction_key = faction:name()
			
			for i = 1, #monster_hunts_index do
				if monster_hunts_index[i] == mission_index then
					activate_a_monster_hunt(mission_index, faction_key, monster_hunts_other_faction[faction_key], UIComponent(context.component):Parent(false, "book_of_monster_hunts"));
				
					-- close the panel
					local uic_ok_button = find_uicomponent(core:get_ui_root(), "book_of_monster_hunts", "button_ok");
					
					if uic_ok_button then
						uic_ok_button:SimulateLClick();
					end;
					
					break;
				end;
			end;
		end;
	end,
	true
);

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("Monster_hunts", monster_hunts, context);
	end
);

cm:add_loading_game_callback(
	function(context)
		monster_hunts = cm:load_named_value("Monster_hunts", monster_hunts_default, context);
	end
);