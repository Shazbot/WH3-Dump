-- big name unlocking system
big_name_unlock = {
	cm = false,
	big_name_key = "",
	event = "",
	condition = false
};

local big_name_templates = {
	-- gatecrasher (greasus)
	{
		["big_name_key"] = "wh3_main_character_initiative_ogr_big_name_greasus_gatecrasher",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return context:character():won_battle() and cm:model():pending_battle():battle_type() == "settlement_standard";
			end
	},
	-- hoardmaster (greasus)
	{
		["big_name_key"] = "wh3_main_character_initiative_ogr_big_name_greasus_hoardmaster",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return character_won_battle_against_culture(context:character(), "wh3_main_ogr_ogre_kingdoms");
			end
	},
	-- shockingly obese (greasus)
	{
		["big_name_key"] = "wh3_main_character_initiative_ogr_big_name_greasus_shockingly_obese",
		["event"] = "CharacterPostBattleCaptureOption",
		["condition"] =
			function(context)
				return context:get_outcome_key() == "kill";
			end
	},
	-- tradelord (greasus)
	{
		["big_name_key"] = "wh3_main_character_initiative_ogr_big_name_greasus_tradelord",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				if character:has_military_force() then
					local mf = character:military_force();
					return (mf:active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_SET_CAMP_RAIDING" or mf:active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_LAND_RAID");
				end;
			end
	},
	
	-- ever famished (skrag)
	{
		["big_name_key"] = "wh3_main_character_initiative_ogr_big_name_skrag_ever_famished",
		["event"] = "CharacterTurnEnd",
		["condition"] =
			function(context)
				local character = context:character();
				local mf = false;
				
				if character:has_military_force() then 
					mf = character:military_force();
				end;
				
				if mf then
					local meat = mf:pooled_resource_manager():resource("wh3_main_ogr_meat");
					
					return not meat:is_null_interface() and meat:value() > 50;
				end;
			end
	},
	-- gore harvester (skrag)
	{
		["big_name_key"] = "wh3_main_character_initiative_ogr_big_name_skrag_gore_harvester",
		["event"] = "CharacterPostBattleCaptureOption",
		["condition"] =
			function(context)
				return context:get_outcome_key() == "kill";
			end
	},
	-- maw that walks (skrag)
	{
		["big_name_key"] = "wh3_main_character_initiative_ogr_big_name_skrag_maw_that_walks",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				
				if character:won_battle() then
					local character_faction_name = character:faction():name();
					local pb = cm:model():pending_battle();
					
					local defender_char_cqi, defender_mf_cqi, defender_faction_name = cm:pending_battle_cache_get_defender(1);
					local attacker_char_cqi, attacker_mf_cqi, attacker_faction_name = cm:pending_battle_cache_get_attacker(1);
					
					if defender_faction_name == character_faction_name and pb:has_attacker() then
						return pb:attacker():is_caster();
					elseif attacker_faction_name == character_faction_name and pb:has_defender() then
						return pb:defender():is_caster();
					end;
				end;
			end
	},
	-- world swallower (skrag)
	{
		["big_name_key"] = "wh3_main_character_initiative_ogr_big_name_skrag_world_swallower",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				
				return character:won_battle() and character:battles_won() > 4;
			end
	},
	
	-- arsebelcher
	{
		["big_name_key"] = "wh3_main_character_initiative_ogr_big_name_arsebelcher",
		["event"] = "CharacterTurnStart",
		["condition"] =
			function()
				return cm:random_number(100) < 6;
			end
	},
	-- beastkiller
	{
		["big_name_key"] = "wh3_main_character_initiative_ogr_big_name_beastkiller",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				return character_won_battle_against_culture(context:character(), "wh_dlc03_bst_beastmen");
			end
	},
	-- beastrider
	{
		["big_name_key"] = "wh3_main_character_initiative_ogr_big_name_beastrider",
		["event"] = "CharacterSkillPointAllocated",
		["condition"] =
			function(context)
				return context:skill_point_spent_on() == "wh3_main_skill_ogr_hunter_stonehorn";
			end
	},
	-- bellyslapper
	{
		["big_name_key"] = "wh3_main_character_initiative_ogr_big_name_bellyslapper",
		["event"] = "CharacterPostBattleCaptureOption",
		["condition"] =
			function(context)
				return context:get_outcome_key() == "enslave";
			end
	},
	-- bigbellower
	{
		["big_name_key"] = "wh3_main_character_initiative_ogr_big_name_bigbellower",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				local character = context:character();
				
				return character:won_battle() and ((cm:pending_battle_cache_faction_is_attacker(character:faction():name()) and cm:pending_battle_cache_num_attackers() > 1) or cm:pending_battle_cache_num_defenders() > 1);
			end
	},
	-- bonechewer
	{
		["big_name_key"] = "wh3_main_character_initiative_ogr_big_name_bonechewer",
		["event"] = "CharacterTurnEnd",
		["condition"] =
			function(context)
				local character = context:character();
				local mf = false;
				
				if character:has_military_force() then 
					mf = character:military_force();
				elseif character:is_embedded_in_military_force() then
					mf = character:embedded_in_military_force();
				end;
				
				if mf then
					local meat = mf:pooled_resource_manager():resource("wh3_main_ogr_meat");
					
					return not meat:is_null_interface() and meat:value() > 50;
				end;
			end
	},
	-- boommaker
	{
		["big_name_key"] = "wh3_main_character_initiative_ogr_big_name_boommaker",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				local character = context:character();
				
				return character:won_battle() and char_army_has_unit(character, "wh3_main_ogr_inf_leadbelchers_0");
			end
	},
	-- brawlerguts
	{
		["big_name_key"] = "wh3_main_character_initiative_ogr_big_name_brawlerguts",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				local character = context:character();
				
				return character:won_battle() and character:battles_won() > 4;
			end
	},
	-- campmaker
	{
		["big_name_key"] = "wh3_main_character_initiative_ogr_big_name_campmaker",
		["event"] = "SpawnableForceCreatedEvent",
		["condition"] =
			function(context)
				return true;
			end
	},
	-- chaos_slayer
	{
		["big_name_key"] = "wh3_main_character_initiative_ogr_big_name_chaos_slayer",
		["event"] = "GarrisonOccupiedEvent",
		["condition"] =
			function(context)
				local region_name = context:garrison_residence():region():name();
				
				return region_name == "wh3_main_chaos_region_the_challenge_stone" or region_name == "wh3_main_combi_region_the_challenge_stone";
			end
	},
	-- daemonbreaker
	{
		["big_name_key"] = "wh3_main_character_initiative_ogr_big_name_daemonbreaker",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				local character = context:character();
				
				return character_won_battle_against_culture(character, {"wh3_main_kho_khorne", "wh3_main_nur_nurgle", "wh3_main_tze_tzeentch", "wh3_main_sla_slaanesh", "wh3_main_dae_daemons"})
			end
	},
	-- deathcheater
	{
		["big_name_key"] = "wh3_main_character_initiative_ogr_big_name_deathcheater",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				return not context:character():won_battle();
			end
	},
	-- dwarfsquasher
	{
		["big_name_key"] = "wh3_main_character_initiative_ogr_big_name_dwarfsquasher",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				return character_won_battle_against_culture(context:character(), "wh_main_dwf_dwarfs");
			end
	},
	-- elfmulcher
	{
		["big_name_key"] = "wh3_main_character_initiative_ogr_big_name_elfmulcher",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)				
				return character_won_battle_against_culture(context:character(), {"wh2_main_hef_high_elves", "wh_dlc05_wef_wood_elves", "wh2_main_def_dark_elves"});
			end
	},
	-- giantbreaker
	{
		["big_name_key"] = "wh3_main_character_initiative_ogr_big_name_giantbreaker",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				return character_won_battle_against_unit(context:character(), {"wh3_main_ogr_mon_giant_0", "wh_dlc03_bst_mon_giant_0", "wh_dlc08_nor_mon_norscan_giant_0", "wh_main_chs_mon_giant", "wh_main_grn_mon_giant"});
			end
	},
	-- gnoblarkicker
	{
		["big_name_key"] = "wh3_main_character_initiative_ogr_big_name_gnoblarkicker",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				local character = context:character();
				
				return character:won_battle() and count_char_army_has_unit(character, {"wh3_main_ogr_inf_gnoblars_0", "wh3_main_ogr_inf_gnoblars_1"}) > 4;
			end
	},
	-- goldhoarder
	{
		["big_name_key"] = "wh3_main_character_initiative_ogr_big_name_goldhoarder",
		["event"] = "CharacterSackedSettlement",
		["condition"] =
			function()
				return true;
			end
	},
	-- grandfeaster
	{
		["big_name_key"] = "wh3_main_character_initiative_ogr_big_name_grandfeaster",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				return context:character():rank() >= 40;
			end
	},
	-- groundbreaker
	{
		["big_name_key"] = "wh3_main_character_initiative_ogr_big_name_groundbreaker",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				return character_won_battle_against_culture(context:character(), "wh3_main_cth_cathay");
			end
	},
	-- gutcrusher
	{
		["big_name_key"] = "wh3_main_character_initiative_ogr_big_name_gutcrusher",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				local character = context:character();
				
				if character:won_battle() then
					local character_faction_name = character:faction():name();
					local pb = cm:model():pending_battle();
					
					local defender_char_cqi, defender_mf_cqi, defender_faction_name = cm:pending_battle_cache_get_defender(1);
					local attacker_char_cqi, attacker_mf_cqi, attacker_faction_name = cm:pending_battle_cache_get_attacker(1);
					
					if attacker_faction_name == character_faction_name then
						return pb:attacker_kills() > 2500;
					elseif defender_faction_name == character_faction_name then
						return pb:defender_kills() > 2500;
					end;
				end;
			end
	},
	-- kineater
	{
		["big_name_key"] = "wh3_main_character_initiative_ogr_big_name_kineater",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				
				if not character:won_battle() then
					local character_faction_name = character:faction():name();
					local pb = cm:model():pending_battle();
					
					local defender_char_cqi, defender_mf_cqi, defender_faction_name = cm:pending_battle_cache_get_defender(1);
					local attacker_char_cqi, attacker_mf_cqi, attacker_faction_name = cm:pending_battle_cache_get_attacker(1);
					
					if defender_faction_name == character_faction_name then
						return pb:defender_kills() > pb:attacker_kills();
					elseif attacker_faction_name == character_faction_name then
						return pb:attacker_kills() > pb:defender_kills();
					end;
				end;
			end
	},
	-- lizardstrangler
	{
		["big_name_key"] = "wh3_main_character_initiative_ogr_big_name_lizardstrangler",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				return character_won_battle_against_culture(context:character(), "wh2_main_lzd_lizardmen");
			end
	},
	-- longstrider
	{
		["big_name_key"] = "wh3_main_character_initiative_ogr_big_name_longstrider",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				return context:character():rank() >= 10;
			end
	},
	-- magichunter
	{
		["big_name_key"] = "wh3_main_character_initiative_ogr_big_name_magichunter",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				local character = context:character();
				
				if character:won_battle() then
					local character_faction_name = character:faction():name();
					local pb = cm:model():pending_battle();
					
					local defender_char_cqi, defender_mf_cqi, defender_faction_name = cm:pending_battle_cache_get_defender(1);
					local attacker_char_cqi, attacker_mf_cqi, attacker_faction_name = cm:pending_battle_cache_get_attacker(1);
					
					if defender_faction_name == character_faction_name and pb:has_attacker() then
						return pb:attacker():is_caster();
					elseif attacker_faction_name == character_faction_name and pb:has_defender() then
						return pb:defender():is_caster();
					end;
				end;
			end
	},
	-- maneater
	{
		["big_name_key"] = "wh3_main_character_initiative_ogr_big_name_maneater",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				return character_won_battle_against_culture(context:character(), {"wh_main_emp_empire", "wh_main_brt_bretonnia"});
			end
	},
	-- mawseeker
	{
		["big_name_key"] = "wh3_main_character_initiative_ogr_big_name_mawseeker",
		["event"] = "GarrisonOccupiedEvent",
		["condition"] =
			function(context)
				local region_name = context:garrison_residence():region():name();
				
				return region_name == "wh3_main_chaos_region_xen_wu" or region_name == "wh3_main_combi_region_xen_wu";
			end
	},
	-- mountaineater
	{
		["big_name_key"] = "wh3_main_character_initiative_ogr_big_name_mountaineater",
		["event"] = "GarrisonOccupiedEvent",
		["condition"] =
			function(context)
				return context:garrison_residence():region():settlement():get_climate() == "climate_mountain";
			end
	},
	-- mountaintalker
	{
		["big_name_key"] = "wh3_main_character_initiative_ogr_big_name_mountaintalker",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				if context:character():won_battle() then
					local region = cm:get_region(cm:model():pending_battle():region_data():key());
					
					return region and region:settlement():get_climate() == "climate_mountain";
				end;
			end
	},
	-- ogrekiller
	{
		["big_name_key"] = "wh3_main_character_initiative_ogr_big_name_ogrekiller",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				return character_won_battle_against_culture(context:character(), "wh3_main_ogr_ogre_kingdoms");
			end
	},
	-- orcsplitter
	{
		["big_name_key"] = "wh3_main_character_initiative_ogr_big_name_orcsplitter",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				return character_won_battle_against_culture(context:character(), "wh_main_grn_greenskins");
			end
	},
	-- ratkiller
	{
		["big_name_key"] = "wh3_main_character_initiative_ogr_big_name_ratkiller",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				return character_won_battle_against_culture(context:character(), "wh2_main_skv_skaven");
			end
	},
	-- staydeader
	{
		["big_name_key"] = "wh3_main_character_initiative_ogr_big_name_staydeader",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				return character_won_battle_against_culture(context:character(), {"wh_main_vmp_vampire_counts", "wh2_dlc09_tmb_tomb_kings", "wh2_dlc11_cst_vampire_coast"});
			end
	},
	-- wallcrusher
	{
		["big_name_key"] = "wh3_main_character_initiative_ogr_big_name_wallcrusher",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				return context:character():won_battle() and cm:model():pending_battle():battle_type() == "settlement_standard";
			end
	}
};

function big_name_unlock_listeners()
	local human_factions = cm:get_human_factions()
	local human_ogre_faction_exists = false;
	
	for i = 1, #human_factions do
		local current_faction = cm:get_faction(human_factions[i]);
		
		if current_faction:culture() == "wh3_main_ogr_ogre_kingdoms" then
			human_ogre_faction_exists = true;
			local character_list = current_faction:character_list();
			
			for j = 0, character_list:num_items() - 1 do
				local current_character = character_list:item_at(j);
				
				if not current_character:character_type("colonel") and not current_character:character_details():character_initiative_sets():is_empty() then
					collect_big_names(current_character);
				end;
			end;
		end;
	end;
	
	if human_ogre_faction_exists then
		core:add_listener(
			"ogre_created",
			"CharacterCreated",
			function(context)
				local character = context:character();
				local faction = character:faction();
				
				return faction:is_human() and faction:culture() == "wh3_main_ogr_ogre_kingdoms" and not character:character_type("colonel") and not character:character_details():character_initiative_sets():is_empty();
			end,
			function(context)
				collect_big_names(context:character());
			end,
			true
		);
	end;
end;

function collect_big_names(character)
	local character_initiative_sets = character:character_details():character_initiative_sets();
	
	local character_initiative_set = character_initiative_sets:item_at(0); -- assume the characters only have one set of initiatives
	
	for i = 0, character_initiative_set:all_initiatives():num_items() - 1 do
		local current_initiative = character_initiative_set:all_initiatives():item_at(i);
		local current_initiative_key = current_initiative:record_key();
		
		if current_initiative:is_script_locked() then
			for j = 1, #big_name_templates do
				local current_big_name_template = big_name_templates[j];
				
				if current_initiative_key == current_big_name_template.big_name_key then
					local big_name = big_name_unlock:new(
						current_big_name_template.big_name_key,
						current_big_name_template.event,
						current_big_name_template.condition
					);
					
					big_name:start(character:command_queue_index());
				end;
			end;
		end;
	end;
end;

function big_name_unlock:new(big_name_key, event, condition)
	if is_string(event) then
		event = {event};
	end;
	
	if not is_string(big_name_key) then
		script_error("ERROR: big_name_unlock:new() called but supplied big_name_key [" .. tostring(big_name_key) .."] is not a string");
		return false;
	elseif not is_table(event) then
		script_error("ERROR: big_name_unlock:new() called but supplied event [" .. tostring(event) .."] is not a table");
		return false;
	elseif not is_function(condition) then
		script_error("ERROR: big_name_unlock:new() called but supplied condition [" .. tostring(condition) .."] is not a function");
		return false;
	end;
	
	local big_name = {};
	setmetatable(big_name, self);
	self.__index = self;
	
	big_name.cm = get_cm();
	big_name.big_name_key = big_name_key;
	big_name.event = event;
	big_name.condition = condition;
	
	return big_name;
end;

function big_name_unlock:start(cqi)
	local cm = self.cm;
	
	out.design("Big names -- Starting listener for big name with key [" .. self.big_name_key .. "] for character with cqi [" .. cqi .. "]");
	
	for i = 1, #self.event do
		core:add_listener(
			self.big_name_key .. "_" .. cqi .. "_listener",
			self.event[i],
			function(context)
				local character_cqi = false;
				
				-- get the characters cqi from the event
				if is_function(context.character) and context:character() then
					character_cqi = context:character():command_queue_index();
				elseif is_function(context.parent_character) and context:parent_character() then
					character_cqi = context:parent_character():command_queue_index();
				end;
				
				return character_cqi and character_cqi == cqi and self.condition(context);
			end,
			function()
				out.design("Big names -- Conditions met for event [" .. self.event[i] .. "], unlocking big name with key [" .. self.big_name_key .. "] for character with cqi [" .. cqi .. "]");
				
				local character = cm:get_character_by_cqi(cqi);
				
				cm:toggle_character_initiative_script_locked(character:character_details():character_initiative_sets():item_at(0), self.big_name_key, false);
				
				core:remove_listener(self.big_name_key .. "_" .. cqi .. "_listener");

				-- Save number of big names unlocked by this faction, and trigger an event for narrative scripts
				local saved_value_name = "num_big_names_unlocked_" .. character:faction():name();
				local num_big_names_unlocked = cm:get_saved_value(saved_value_name) or 0;
				cm:set_saved_value(saved_value_name, num_big_names_unlocked + 1);
				core:trigger_custom_event("ScriptEventBigNameUnlocked", {character = character, big_name_key = self.big_name_key});
			end,
			false
		);
	end;
end;