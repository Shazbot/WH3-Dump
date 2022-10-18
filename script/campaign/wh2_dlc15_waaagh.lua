waaagh = {
	greenskin_culture = "wh_main_grn_greenskins",
	greenskin_subculture = "wh_main_sc_grn_greenskins",
	pooled_resource = "grn_waaagh",
	waaagh_per_turn = 1, -- Passive gain per turn
	waaagh_ended = -100, -- Waaagh removed after a waaagh ends. -100 ensures the resource resets to 0
	battle_mod = 0.015, -- Multiplier applied to kills to work out how much waaagh is earned from Battles. Default 0.015, higher = more resource
	ai_cooldown = 30, -- Number of turns before we roll for AI boosts to automatically start a waaargh
	ai_boost = 100, -- Amount of Waaagh AI will get when boosted. 100 guarantees it'll trigger a waaagh
	ai_boost_chance = 20, -- %chance/turn AI will get ai_boost added to waaagh if they haven't triggered a waaagh for ai_cooldown+ turns
	button_key = "shard_animation",
	ritual_key = "wh2_main_ritual_grn_waaagh",
	composite_scene = "waaagh_ui_target";
	level_3_threshold = 10, -- Target faction ranking required for best rewards
	level_2_threshold = 30, -- Target faction ranking required for second best rewards
	successful_waaagh_boost = 10, -- Amount of bonus resource for winning a waaagh. Multiplied by the level
	big_waaagh_bundles = {
		wh_main_grn_grimgor_ironhide = "wh2_dlc15_bundle_grimgors_big_waaagh_army_ability",
		wh_main_grn_azhag_the_slaughterer = "wh2_dlc15_bundle_azhags_big_waaagh_army_ability",
		wh2_dlc15_grn_grom_the_paunch = "wh2_dlc15_bundle_groms_big_waaagh_army_ability",
		wh_dlc06_grn_skarsnik = "wh2_dlc15_bundle_skarsniks_big_waaagh_army_ability",
		wh_dlc06_grn_wurrzag_da_great_prophet = "wh2_dlc15_bundle_wurrzags_big_waaagh_army_ability"
	},
	factions = {}, -- Dynamic script data populated on first tick and maintained by the script
	faction_data = { -- Table containing playing greenskin factions unique event feed strings
		wh_main_grn_greenskins = {
			event_title = "event_feed_strings_text_wh2_main_event_feed_string_scripted_event_grn_waaagh_title_grimgor",
			event_description = "event_feed_strings_text_wh2_main_event_feed_string_scripted_event_grn_waaagh_description_grimgor",
		},
		wh_main_grn_crooked_moon = {
			event_title = "event_feed_strings_text_wh2_main_event_feed_string_scripted_event_grn_waaagh_title_skarsnik",
			event_description = "event_feed_strings_text_wh2_main_event_feed_string_scripted_event_grn_waaagh_description_skarsnik",
		},
		wh_main_grn_orcs_of_the_bloody_hand = {
			event_title = "event_feed_strings_text_wh2_main_event_feed_string_scripted_event_grn_waaagh_title_wurrzag",
			event_description = "event_feed_strings_text_wh2_main_event_feed_string_scripted_event_grn_waaagh_description_wurrzag",
		},
		wh2_dlc15_grn_broken_axe = {
			event_title = "event_feed_strings_text_wh2_main_event_feed_string_scripted_event_grn_waaagh_title_grom",
			event_description = "event_feed_strings_text_wh2_main_event_feed_string_scripted_event_grn_waaagh_description_grom",
		},
		wh2_dlc15_grn_bonerattlaz = {
			event_title = "event_feed_strings_text_wh2_main_event_feed_string_scripted_event_grn_waaagh_title_azhag",
			event_description = "event_feed_strings_text_wh2_main_event_feed_string_scripted_event_grn_waaagh_description_azhag",
		}
	},
	-- All Legendary Lord greenskins require a slightly different version of the 'confederate' event: as they can't die, the 'kill lord' option should be removed.
	greenskin_legendary_lords = {
		wh_main_grn_grimgor_ironhide = true,
		wh_dlc06_grn_skarsnik = true,
		wh2_dlc15_grn_grom_the_paunch = true,
		wh_main_grn_azhag_the_slaughterer = true,
		wh_dlc06_grn_wurrzag_da_great_prophet = true,
	},
	confederate_dilemma_key = "wh2_main_grn_confederate_wh2_dlc15_grn_generic",
	confederate_for_lls_dilemma_key = "wh2_main_grn_confederate_wh2_dlc15_grn_generic_no_execution",
	confederation_dilemma_execution_option = 1,	-- (Zero-based) index of the option in the confederation dilemma that causes the enemy leader to die.
	rewards = {
		["humans"] = {
			culture = {
				wh_main_emp_empire = true,
				wh_main_brt_bretonnia = true,
				wh3_main_ksl_kislev = true,
				wh3_main_cth_cathay = true
			}
		},
		["dwarfs"] = {
			culture = {
				wh_main_dwf_dwarfs = true
			}
		},
		["chaos"] = {
			culture = {
				wh_main_chs_chaos = true,
				wh_dlc08_nor_norsca = true,
				wh2_main_rogue = true,
				wh_dlc03_bst_beastmen = true
			}
		},
		["undead"] = {
			culture = {
				wh2_dlc09_tmb_tomb_kings = true,
				wh2_dlc11_cst_vampire_coast = true,
				wh_main_vmp_vampire_counts = true
			}
		},
		["elves"] = {
			culture = {
				wh2_main_def_dark_elves = true,
				wh2_main_hef_high_elves = true,
				wh_dlc05_wef_wood_elves = true
			}
		},
		["greenskins"] = {
			culture = {
				wh_main_grn_greenskins = true
			}
		},
		["lizardmen"] = {
			culture = {
				wh2_main_lzd_lizardmen = true
			}
		},
		["skaven"] = {
			culture = {
				wh2_main_skv_skaven = true
			},
		},
		["daemons"] = {
			culture = {
				wh3_main_tze_tzeentch = true,
				wh3_main_sla_slaanesh = true,
				wh3_main_nur_nurgle = true,
				wh3_main_kho_khorne = true,
				wh3_main_dae_daemons = true
			},
		},
		["ogres"] = {
			culture = {
				wh3_main_ogr_ogre_kingdoms = true
			},
		},
	},
	max_level = 3, -- Default 3. Maximum level for waaagh rewards. Needs both effect bundles and waaagh.units added to support if increased
	waaagh_from_tech = 5, -- Default 5. Passive waaagh/turn from the tech that grants it. Needs updating in tech effects table if changed
	units = {
		level_1 = {
			"wh2_dlc15_grn_cav_forest_goblin_spider_riders_waaagh_0",
			"wh_dlc06_grn_inf_squig_explosive_0"
		},
		level_2 = {
			"wh2_dlc15_grn_cav_squig_hoppers_waaagh_0",
			"wh2_dlc15_grn_mon_wyvern_waaagh_0"
		},
		level_3 = {
			"wh_dlc15_grn_mon_arachnarok_spider_waaagh_0",
			"wh2_dlc15_grn_mon_feral_hydra_waaagh_0"
		}
	},
	event_pic = 1313, -- The id of the event pic used for the waaagh event feed events.

	-- Recource Factors
	rs_waagh_per_turn = "wh2_dlc15_resource_factor_waaagh_per_turn",
	rs_waagh_triggered = "wh2_dlc15_resource_factor_waaagh_triggered",
	rs_waagh_success = "wh2_dlc15_resource_factor_waaagh_success",
	rs_waagh_other = "wh2_dlc15_resource_factor_waaagh_other",
	rs_waagh_battle_other = "wh2_dlc15_resource_factor_waaagh_battle_other"
}

function waaagh:add_waaagh_listeners()
	out("#### Adding waaagh Listeners ####");

	if cm:is_new_game() == true then
		-- Construct tables for scripted data for each faction in the self.factions list
		local default_faction_setup = {
			reward_level = nil,
			reward_culture = nil,
			previous_reward_level = nil,
			previous_reward_culture = nil,
			gork_counter = 0,
			mork_counter = 0,
			ai_counter = 0,
			advice_reminder_counter = 0,
			ritual_region_key = nil,
			success = false,
			active_waaagh = false
		}
		for k,v in pairs(self.faction_data) do

			self.factions[k] = table.copy(default_faction_setup)

		end
	end

	cm:add_faction_turn_start_listener_by_subculture(
		"Waaagh_FactionTurnStart_listener",
		self.greenskin_subculture,
		function(context)
			local faction_key = context:faction():name();
			if self.factions[faction_key] then
				
				-- passive waaagh gain per turn for greenskins
				local passive_gain = self.waaagh_per_turn
				if context:faction():has_technology("tech_grn_final_1_2") then
					passive_gain = passive_gain + self.waaagh_from_tech
				end
				self:modify_pooled_resource(faction_key, self.rs_waagh_per_turn, passive_gain);

				if context:faction():is_human() then
					self:faction_turn_start_human(context:faction(), faction_key);
				else
					self:faction_turn_start_ai(context:faction());
				end;
			end
		end,
		true
	);
	core:add_listener(
		"Waaagh_BattleCompleted_listener",
		"BattleCompleted",
		function(context)
			return cm:model():pending_battle():has_been_fought();
		end,
		function(context)
			self:battle_completed();
		end,
		true
	);
	core:add_listener(
		"Waaagh_RitualStartedEvent_listener",
		"RitualStartedEvent",
		function(context)
			return context:ritual():ritual_key() == self.ritual_key
		end,
		function(context)
			faction = context:performing_faction()
			self.factions[faction:name()].active_waaagh = true
			if faction:is_human() then
				self:waaagh_started(context);
			else
				self.factions[faction:name()].ai_counter = 0;
			end
		end,
		true
	);
	core:add_listener(
		"Waaagh_RitualCompletedEvent_listener",
		"RitualCompletedEvent",
		function(context)
			return context:ritual():ritual_key() == self.ritual_key
		end,
		function(context)
			self.factions[context:performing_faction():name()].active_waaagh = false
			if context:performing_faction():is_human() then
				self:waaagh_ended_human(context);
			else
				self:waaagh_ended_ai(context);
			end
		end,
		true
	);
	core:add_listener(
		"Waaagh_Ritual_Target_Razed_listener",
		"CharacterRazedSettlement",
		function(context)
			local faction = context:character():faction()
			return faction:is_human() and self.factions[faction:name()] and context:garrison_residence():region():name() == self.factions[faction:name()].ritual_region_key
		end,
		function(context)
			local faction_key = context:character():faction():name()
			self.factions[faction_key].success = true;
			out.design("### Waaagh target has been razed: WAAAGH! was a success")
			cm:trigger_incident(faction_key,"wh_main_incident_grn_waaagh_success_raze", true)
		end,
		true
	);
	core:add_listener(
		"Waaagh_Ritual_Target_Occupied_listener",
		"GarrisonOccupiedEvent",
		function(context)
			local faction = context:character():faction()
			return faction:is_human() and self.factions[faction:name()] and context:garrison_residence():region():name() == self.factions[faction:name()].ritual_region_key 
		end,
		function(context)
			local faction = context:character():faction():name()
			out.design("### Waaagh target has been occupied and needs to be held")
			cm:trigger_incident(faction,"wh_main_incident_grn_waaagh_success_occupy", true)
		end,
		true
	);
	-- if Greenskins are confederated during an active Waaagh, check if LL and apply Waaagh bundle for LL
	core:add_listener(
		"Waaagh_FactionJoinsConfederation_Big_Waaagh_listener",
		"FactionJoinsConfederation",
		function(context)
			return context:confederation():is_human() and context:confederation():subculture() == self.greenskin_subculture
		end,
		function(context)
			local faction = context:confederation();
			local bundles = faction:effect_bundles();
			local waaagh_turns = 1;
			for i = 0, bundles:num_items() - 1 do
				if bundles:item_at(i):key() == "wh2_main_faction_boost_gork" or bundles:item_at(i):key() == "wh2_main_faction_boost_mork" then
					waaagh_turns = bundles:item_at(i):duration();
				end
			end

			self:battle_big_waaagh_upgrade(faction, waaagh_turns);
		end,
		true
	);
	-- if during an active Waaagh and LL is recruited, make sure to apply Waaagh bundle for LL
	core:add_listener(
		"Waaagh_MilitaryForceCreated_Big_Waaagh_listener",
		"MilitaryForceCreated",
		function(context)
			return context:military_force_created():faction():is_human() and context:military_force_created():faction():subculture() == self.greenskin_subculture
		end,
		function(context)
			local faction = context:military_force_created():faction();
			local bundles = faction:effect_bundles();
			local waaagh_turns = 1;
			for i = 0, bundles:num_items() - 1 do
				if bundles:item_at(i):key() == "wh2_main_faction_boost_gork" or bundles:item_at(i):key() == "wh2_main_faction_boost_mork" then
					waaagh_turns = bundles:item_at(i):duration();
				end
			end

			self:battle_big_waaagh_upgrade(faction, waaagh_turns);
		end,
		true
	);
	-- if during an active Waaagh and LL replaces general of existing military force, make sure to apply Waaagh bundle for LL
	core:add_listener(
		"Waaagh_CharacterReplacingGeneral_Big_Waaagh_listener",
		"CharacterReplacingGeneral",
		function(context)
			return context:character():faction():is_human() and context:character():faction():subculture() == self.greenskin_subculture
		end,
		function(context)
			local faction = context:character():faction();
			local bundles = faction:effect_bundles();
			local waaagh_turns = 1;
			for i = 0, bundles:num_items() - 1 do
				if bundles:item_at(i):key() == "wh2_main_faction_boost_gork" or bundles:item_at(i):key() == "wh2_main_faction_boost_mork" then
					waaagh_turns = bundles:item_at(i):duration();
				end
			end

			self:battle_big_waaagh_upgrade(faction, waaagh_turns);
		end,
		true
	);
	-- Gork or Mork selection
	core:add_listener(
		"Waaagh_Mork_or_Gork_button_listener",
		"ComponentLClickUp",
		function(context)
			if context.string == "mork_button" or context.string == "gork_button" then
				return true;
			end
		end,
		function(context)
			local faction_cqi = cm:get_local_faction(true):command_queue_index();
			
			if context.string == "mork_button" then
				CampaignUI.TriggerCampaignScriptEvent(faction_cqi, "waaagh_mork_selection");
			elseif context.string == "gork_button" then
				CampaignUI.TriggerCampaignScriptEvent(faction_cqi, "waaagh_gork_selection");
			end
		end,
		true
	);
	core:add_listener(
		"Waaagh_Mork_or_Gork_Selection_listener",
		"UITrigger",
		function(context)
			return context:trigger() == "waaagh_gork_selection" or context:trigger() == "waaagh_mork_selection";
		end,
		function(context)
			local faction = cm:model():faction_for_command_queue_index(context:faction_cqi());
			local faction_key = faction:name();
			local god = ""

			if context:trigger() == "waaagh_gork_selection" then
				god = "gork";
				self.factions[faction_key].gork_counter = self.factions[faction_key].gork_counter + 1;
				self.factions[faction_key].mork_counter = 0;
			else
				god = "mork";
				self.factions[faction_key].mork_counter = self.factions[faction_key].mork_counter + 1;
				self.factions[faction_key].gork_counter = 0;
			end

			out.design("### WAAAGH! dedicated to "..god.."!");
			cm:apply_effect_bundle("wh2_main_faction_boost_"..god, faction_key, 20);
			common.set_context_value("waaagh_god_"..faction_key, god);
			self:battle_big_waaagh_upgrade(faction, 20);	

		end,
		true
	);

	cm:add_immortal_character_defeated_listener(
		"GreenskinLordDefeatedConfederateEvent",
		function(context)
			-- Start checking if we need a Greenskin Confederate event if both attackers and defenders have greenskin armies involved.
			return cm:pending_battle_cache_culture_is_attacker(self.greenskin_culture) and cm:pending_battle_cache_culture_is_defender(self.greenskin_culture);
		end,
		self.trigger_confederate_dilemma,
		true
	);

	core:add_listener(
		"Waaagh_ComponentLClickUp",
		"ComponentLClickUp",
		function(context)
			if context.string == self.button_key then
				return true;
			end
		end,
		function(context)
			core:trigger_event("ScriptEventWaghSelect");
		end,
		true
	);
	core:add_listener(
		"Waaagh_Cancelled",
		"RitualCancelledEvent",
		function(context)
			return context:ritual():ritual_key() == self.ritual_key
		end,
		function(context)
			local faction_key = context:performing_faction():name()
			local region_key = self.factions[faction_key].ritual_region_key
			
			if region_key then
				local comp_scene;
				
				if context:performing_faction():is_human() then
					comp_scene = "waaagh_"..region_key;
				else
					comp_scene = "waaagh_ai_"..region_key;
				end
				
				cm:remove_scripted_composite_scene(comp_scene);
				out.design("### WAAAGH! ended removing VFX "..comp_scene)
			end
			
			self.factions[faction_key].ritual_region_key = nil;
			self.factions[faction_key].active_waaagh = false
		end,
		true
	);
end

function waaagh.trigger_confederate_dilemma(victorious_fm, defeated_fm)
	local victorious_character = victorious_fm:character();
	local defeated_character = defeated_fm:character();

	if not victorious_character or victorious_character:is_null_interface() then
		script_error("ERROR: Victorious character could not be obtained from victorious family member when trying to launch Greenskin confederation dilemma after a battle. "
			.. "Is the victorious character dead? How did this happen if they won the battle?");
		return;
	end

	if not defeated_character or defeated_character:is_null_interface() then
		script_error("ERROR: Defeated character could not be obtained from Defeated family member when trying to launch Greenskin confederation dilemma after a battle. "
			.. "This function should have been called after the defeated character respawned post-battle. Why hasn't this happened?");
		return;
	end
	
	local defeated_faction = defeated_character:faction();

	if defeated_faction:is_human() or defeated_faction:subculture() ~= waaagh.greenskin_subculture or not defeated_character:is_faction_leader() then
		return;
	end

	local victorious_faction = victorious_character:faction();

	if victorious_faction:culture() == waaagh.greenskin_culture then
		if victorious_faction:is_human() then
			-- For Legendary Lords, we need to use the dilemma that doesn't have the 'execute enemy boss' option.
			local confederate_dilemma_key = waaagh.confederate_dilemma_key;
			if waaagh.greenskin_legendary_lords[defeated_character:character_subtype_key()] ~= nil then
				confederate_dilemma_key = waaagh.confederate_for_lls_dilemma_key;
			end

			-- Trigger dilemma to offer confederation
			cm:trigger_dilemma_with_targets(victorious_faction:command_queue_index(),
				confederate_dilemma_key,
				defeated_character:faction():command_queue_index(),
				0,
				defeated_character:command_queue_index(),
				0,
				0,
				0,
				function() waaagh:add_listener_for_confederation_dilemma(defeated_character:family_member():command_queue_index()) end);
		else
			-- AI confederation
			cm:force_confederation(victorious_faction:name(), defeated_character:faction():name());
			out.design("###### AI GREENSKIN CONFEDERATION");
			out.design("Faction: ".. victorious_faction:name().." is confederating ".. defeated_character:faction():name());
		end
	end
end

-- Check to see if the player chooses the execution option with the confederation dilemma, and if so kill the character off
function waaagh:add_listener_for_confederation_dilemma(enemy_leader_family_member_key)
	core:add_listener(
		"Waaagh_DilemmaChoiceMadeEvent_Confederation_listener",
		"DilemmaChoiceMadeEvent",
		true,
		function(context)
			if context:dilemma() == self.confederate_dilemma_key and context:choice() == self.confederation_dilemma_execution_option then
				-- Autosave on legendary.
				if cm:model():difficulty_level() == -3 and not cm:is_multiplayer() then
					cm:callback(function() cm:autosave_at_next_opportunity() end, 0.5);
				end;
				
				waaagh:greenskin_force_kill_leader(enemy_leader_family_member_key);
			end;
		end,
		false
	);
end

function waaagh:greenskin_force_kill_leader(enemy_leader_family_member_key)
	local character_interface = cm:get_family_member_by_cqi(enemy_leader_family_member_key):character();
	local character_cqi = character_interface:command_queue_index();

	if self.greenskin_legendary_lords[character_interface:character_subtype_key()] then
		script_error(string.format("ERROR: Attempt was made to force-kill one of the greenskin legendary lords ('%s'): this should not be possible through events, as legendary lords should trigger a confederation dilemma with no execution option. Aborting process.",
			character_interface:character_subtype_key()));
		return;
	end
	out("wh2_dlc15_waaagh script: Player has chosen execute option in dilemma. Target character: " .. character_interface:get_forename());
	cm:set_character_immortality("character_cqi:"..character_cqi, false);
	cm:kill_character(character_cqi, false);
end

--function to apply and remove the LL versions of the Big Waaagh! battle army abilities
function waaagh:battle_big_waaagh_upgrade(faction, waaagh_turns)
	
	local mf_list = faction:military_force_list();

	--loop through list to find any GS LL
	for i = 0, mf_list:num_items() - 1 do
		local force = mf_list:item_at(i);
		local character = force:general_character();
		local character_cqi = character:command_queue_index();

		--Removing all bundles first handles cases where a LL has been replaced with someone else
		for k, v in pairs(self.big_waaagh_bundles) do
			cm:remove_effect_bundle_from_characters_force(v, character_cqi);
		end

		if self.big_waaagh_bundles[character:character_subtype_key()] ~= nil then
			cm:apply_effect_bundle_to_characters_force(self.big_waaagh_bundles[character:character_subtype_key()], character_cqi, waaagh_turns);
		end

	end
	
end

function waaagh:waaagh_started(context)
	local ritual_target = context:ritual():ritual_target()
	local ritual_region = ritual_target:get_target_region()
	local ritual_region_key = ritual_region:name()
	local ritual_region_owner = ritual_region:owning_faction()
	local ritual_region_owner_culture = ritual_region_owner:culture()
	local faction_key = context:performing_faction():name()
	local reward_culture = "humans"

	out.design("##### Waaagh Started - Ritual target region name: "..ritual_region_key)
	
	for key, value in pairs(self.rewards) do
		if value.culture[ritual_region_owner_culture] ~= nil then
			reward_culture = key
			break
		end
	end	

	local uic_waaagh_top_bar = find_uicomponent("waaaagh_holder", "waaagh_top_bar")

	if not uic_waaagh_top_bar then
		script_error("ERROR: uic_waaagh_top_bar could not be found")
		return
	end

	local reward_value = cm:model():world():faction_strength_rank(ritual_region_owner);
	local reward_level = ""

	if reward_value <= self.level_3_threshold then
		reward_level = 3
	elseif reward_value <= self.level_2_threshold then
		reward_level = 2
	else
		reward_level = 1
	end

	-- Apply current preview reward
	cm:apply_effect_bundle("wh2_main_faction_boost_reward_preview_level"..reward_level.."_"..reward_culture, faction_key, 0);

	-- Add Waaagh VFX
	local comp_scene = "waaagh_"..ritual_region_key
	local scene_type = self.composite_scene;

	cm:add_scripted_composite_scene_to_settlement(comp_scene, scene_type, ritual_region, 0, 0, false, true, true);

	-- Update faction specific waaagh data for later reference
	self.factions[faction_key].ritual_region_key = ritual_region_key
	self.factions[faction_key].reward_level = reward_level
	self.factions[faction_key].reward_culture = reward_culture
	
end

function waaagh:waaagh_ended_human(context)
	local faction_key = context:performing_faction():name()
	local region_key = self.factions[faction_key].ritual_region_key
	local region = cm:get_region(region_key)
	
	if not region then
		script_error("ERROR: waaagh_ended_human() called but no region target was found - how did this happen?")
		return false
	end
	
	local waaagh_success = self.factions[faction_key].success or region:is_abandoned() or region:owning_faction():name() == faction_key
	local reward_level = self.factions[faction_key].reward_level
	local reward_culture = self.factions[faction_key].reward_culture

	out.design("##### Waaagh Ended - Ritual target region name: "..region:name())

	-- Remove reward preview
	cm:remove_effect_bundle("wh2_main_faction_boost_reward_preview_level"..reward_level.."_"..reward_culture, faction_key);

	-- Switch active reward
	if self.factions[faction_key].previous_reward_level then
		cm:remove_effect_bundle("wh2_main_faction_boost_reward_"..self.factions[faction_key].previous_reward_level.."_"..self.factions[faction_key].previous_reward_culture, faction_key)
	end

	-- Set Waaagh to 0
	self:modify_pooled_resource(faction_key, self.rs_waagh_triggered, self.waaagh_ended)

	if waaagh_success then
		cm:apply_effect_bundle("wh2_main_faction_boost_reward_level"..reward_level.."_"..reward_culture, faction_key, 0);
		self.factions[faction_key].previous_reward_level = reward_level;
		self.factions[faction_key].previous_reward_culture = reward_culture;

		-- Xiao request for elf trophy
		if reward_culture == "elves" then
			core:trigger_event("PlayerGainedWaghElfTrophy");
		end

		-- trigger successful WAAAGH event
		cm:trigger_incident(faction_key, "wh_main_incident_grn_waaagh_success", true)
		core:trigger_event("PlayerWaghEndedSuccessful");

		out.design("#### Waaagh ended! Reward for culture: "..reward_culture.."! Level: "..reward_level)

		-- Award waaagh and additional unit for successful WAAAGH!
		self:modify_pooled_resource(faction_key, self.rs_waagh_success, self.successful_waaagh_boost*reward_level)
		out.design("### Adding Waaagh units to mercenary pool")
		for i = 1, #self.units["level_"..reward_level] do
			cm:add_units_to_faction_mercenary_pool(context:performing_faction():command_queue_index(), self.units["level_"..reward_level][i], 1);
		end
		self.factions[faction_key].success = false;
	else
		-- trigger fail WAAAGH event
		cm:trigger_incident(faction_key,"wh_main_incident_grn_waaagh_failed", true)
		core:trigger_event("PlayerWaghEndedUnsuccessful");		

		self.factions[faction_key].previous_reward_level = nil;
		self.factions[faction_key].previous_reward_culture = nil;
	end

	local comp_scene = "waaagh_"..region_key;
	cm:remove_scripted_composite_scene(comp_scene);

	self.factions[faction_key].ritual_region_key = nil;
end

function waaagh:faction_turn_start_human(faction, faction_key)

	if self.factions[faction_key].mork_counter == self.max_level then
		cm:trigger_incident(faction_key,"wh2_main_incident_grn_mork_is_happy");
		self.factions[faction_key].mork_counter = 0
	elseif self.factions[faction_key].gork_counter == self.max_level then
		cm:trigger_incident(faction_key,"wh2_main_incident_grn_gork_is_happy");
		self.factions[faction_key].gork_counter = 0
	end

	if self.factions[faction_key].active_waaagh then
		local bundles = faction:effect_bundles();
		local waaagh_turns = 1;
		for i = 0, bundles:num_items() - 1 do
			if bundles:item_at(i):key() == "wh2_main_faction_boost_gork" or bundles:item_at(i):key() == "wh2_main_faction_boost_mork" then
				waaagh_turns = bundles:item_at(i):duration();
			end
		end

		self:battle_big_waaagh_upgrade(faction, waaagh_turns);

		core:trigger_event("ScriptEventWaghTransportedArmies")
	end

	-- Count turns for advice reminder to trigger Waaagh!
	if not self.factions[faction_key].active_waaagh then
		if faction:pooled_resource_manager():resource(self.pooled_resource):value() == 100  then
			self.factions[faction_key].advice_reminder_counter = self.factions[faction_key].advice_reminder_counter + 1;
			core:trigger_event("ScriptEventWaghResourceMax")
		else 
			self.factions[faction_key].advice_reminder_counter = 0
		end

		if self.factions[faction_key].advice_reminder_counter > 5 then
			core:trigger_event("ScriptEventWaghReminder")
		end
	end

end

function waaagh:faction_turn_start_ai(faction)
	local faction_key = faction:name();
	local current_waaagh = faction:pooled_resource_manager():resource(self.pooled_resource):value();

	out.design("### Current Waaagh of AI Greenskin faction "..faction_key.." is "..current_waaagh)
	-- If appropriate AI faction has 100 waaagh trigger WAAAAGH!
	if current_waaagh == 100 and self.factions[faction_key].active_waaagh == false then
		self:waaagh_started_ai(faction);
		return
	-- If AI did not have a WAAAGH! for a period boost the faction
	elseif self.factions[faction_key].ai_counter > self.ai_cooldown and self.factions[faction_key].active_waaagh == false then
		local rand = cm:random_number(100)
		if rand <= self.ai_boost_chance then
			self:modify_pooled_resource(faction_key, self.rs_waagh_other, self.ai_boost);
			out.design("### Applied Waaagh AI boost to faction: "..faction_key);
			self.factions[faction_key].ai_counter = 0;
		end
		return
	end

	-- AI has not triggered a Waaagh, decrease the timer until they are eligible for a boost chance
	self.factions[faction_key].ai_counter = self.factions[faction_key].ai_counter + 1;

end

function waaagh:waaagh_started_ai(faction)
	local target_pos_x = 0;
	local target_pos_y = 0;
	local ritual_setup = cm:create_new_ritual_setup(faction, self.ritual_key)
	local war_factions = faction:factions_at_war_with();
	local ritual_target = ritual_setup:target();
	local unique_war_factions = unique_table:faction_list_to_unique_table(war_factions);
	local possible_factions = unique_war_factions:to_table();
	local target_faction_key = "";
	
	-- Check there's at least 1 potential target, and if so try and find a ritual target
	if #possible_factions > 0 then

		local valid_faction_targets = {}

		-- Find potential target factions
		for i = 1, #possible_factions do
			local possible_faction_key = possible_factions[i];
			local possible_faction = cm:model():world():faction_by_key(possible_faction_key);
			-- Don't target regionless factions
			if possible_faction:region_list():is_empty() == false and possible_faction:has_home_region() and possible_faction:home_region():is_null_interface() == false then
				--Check the home region is a valid ritual target
				local home_region = possible_faction:home_region()
				if ritual_target:is_region_valid_target(home_region) then
					--Ritual target is valid! Add the faction to the viable targets list
					table.insert(valid_faction_targets, possible_faction_key)
				end
			end
		end
	
		-- Pick one of the valid targets at random
		if #valid_faction_targets > 0 then
			local rand = cm:random_number(#valid_faction_targets);
			target_faction_key = valid_faction_targets[rand];
			local target_faction = cm:model():world():faction_by_key(target_faction_key)
			local home_region = target_faction:home_region()
			target_pos_x = home_region:settlement():logical_position_x();
			target_pos_y = home_region:settlement():logical_position_y();
			out.design("####### AI Waaagh target faction is: ".. target_faction_key.." and target region is "..home_region:name())
			ritual_target:set_target_region(home_region);
		else
			-- We don't have any valid targets. Print this to the console, but don't fire an error - this is expected in rare circumstances.
			out.design("####### AI faction: "..faction:name().." wants to start a Waaagh, but there are no valid targets.")
			out.design("This is expected functionality in isolated cases, however if this is spamming something may have gone wrong")
		end
	end

	-- Fire the ritual with above setup
	if ritual_target:valid() then
		local faction_key = faction:name()
		local region = ritual_target:get_target_region();
		local region_key = region:name();
		local target_key = target_faction_key;
		self.factions[faction_key].ritual_region_key = region_key
		cm:perform_ritual_with_setup(ritual_setup);
		core:trigger_custom_event("AIWaaaghStarted", {faction_key = faction_key, region_key = region_key, target_key = target_key});

		-- Tell the target if they're human
		if region:owning_faction():is_human() then
			local title = self.faction_data[faction_key].event_title;
			local description = self.faction_data[faction_key].event_description;
			cm:show_message_event_located(
				region:owning_faction():name(),
				title,
				"regions_onscreen_"..region_key,
				description,
				target_pos_x, 
				target_pos_y,
				true,
				self.event_pic
			);
		end

		-- Add Waaagh VFX for AI
		local comp_scene = "waaagh_ai_"..region_key
		local scene_type = self.composite_scene;

		out.design("### WAAAGH! started adding VFX "..comp_scene)
		cm:add_scripted_composite_scene_to_settlement(comp_scene, scene_type, region, 0, 0, false, true, true);

	end
end

function waaagh:waaagh_ended_ai(context)
	local human_factions = cm:get_human_factions();
	local faction_key = context:performing_faction():name()
	local region = cm:get_region(self.factions[faction_key].ritual_region_key)
	local waaagh_success = region:is_abandoned() or region:owning_faction():name() == faction_key

	-- Set Waaagh to 0
	self:modify_pooled_resource(faction_key, self.rs_waagh_triggered, self.waaagh_ended)

	for i = 1, #human_factions do
		if waaagh_success then
			-- trigger successful WAAAGH event
			cm:trigger_incident(human_factions[i],"wh_main_incident_grn_waaagh_ai_success", true)
			self:modify_pooled_resource(faction_key, self.rs_waagh_success, 50)
		else
			-- trigger fail WAAAGH event
			cm:trigger_incident(human_factions[i],"wh_main_incident_grn_waaagh_ai_failed", true)
		end
	end;

	-- Remove Waaagh VFX for AI
	local comp_scene = "waaagh_ai_"..region:name()
	out.design("### WAAAGH! ended removing VFX "..comp_scene)
	cm:remove_scripted_composite_scene(comp_scene);
	self.factions[faction_key].ritual_region_key = nil;
end


function waaagh:battle_completed()
	local inactive_waaagh_faction = false;
	local rebels = false;
	local attacker_factions = {};
	local defender_factions = {};

		-- Find if rebels are part of the battle
		for i = 1, cm:pending_battle_cache_num_attackers() do
			local attacker_cqi, attacker_force_cqi, attacker_name = cm:pending_battle_cache_get_attacker(i);

			if attacker_name == "rebels" then
				rebels = true;
				break
			elseif self.factions[attacker_name] and self.factions[attacker_name].active_waaagh == false then
				inactive_waaagh_faction = true;
				table.insert(attacker_factions, attacker_name)
			end
		end

		for i = 1, cm:pending_battle_cache_num_defenders() do
			local defender_cqi, defender_force_cqi, defender_name = cm:pending_battle_cache_get_defender(i);

			if defender_name == "rebels" then
				rebels = true;
				break
			elseif self.factions[defender_name] and self.factions[defender_name].active_waaagh == false then
				inactive_waaagh_faction = true;
				table.insert(defender_factions, defender_name)
			end
		end

	if inactive_waaagh_faction and not rebels then

		local attacker_value = cm:pending_battle_cache_attacker_value();
		local defender_value = cm:pending_battle_cache_defender_value();
		local attacker_multiplier = defender_value / attacker_value;
		attacker_multiplier = math.clamp(attacker_multiplier, 0.5, 1.5);
		local kill_ratio_attacker = cm:model():pending_battle():percentage_of_defender_killed();
		local attacker_waaagh = (defender_value / 10) * attacker_multiplier * kill_ratio_attacker;
		local defender_multiplier = attacker_value / defender_value;
		defender_multiplier = math.clamp(defender_multiplier, 0.5, 1.5);
		local kill_ratio_defender = cm:model():pending_battle():percentage_of_attacker_killed();
		local defender_waaagh = (attacker_value / 10) * defender_multiplier * kill_ratio_defender;

		-- Waaagh inactive, add waaagh resource for battles
		if #attacker_factions > 0 then
			for i = 1, #attacker_factions do
				local faction_key = attacker_factions[i]
				local faction = cm:get_faction(faction_key);
				
				local waaagh_reward = attacker_waaagh * self.battle_mod;

				self:modify_pooled_resource(faction_key, self.rs_waagh_battle_other, waaagh_reward);
				self:print_battle(faction_key, waaagh_reward, attacker_value, defender_value, attacker_multiplier, kill_ratio_attacker);

				-- Check pooled resource for Advice trigger
				if faction:pooled_resource_manager():resource(self.pooled_resource):value() == 100 and faction:is_human()  then
					core:trigger_event("ScriptEventWaghResourceMax")
				end

			end
		end

		if #defender_factions > 0 then
			for i = 1, #defender_factions do
				local faction_key = defender_factions[i]
				local faction = cm:get_faction(faction_key);
	
				local waaagh_reward = defender_waaagh * self.battle_mod;

				self:modify_pooled_resource(faction_key, self.rs_waagh_battle_other, waaagh_reward);
				self:print_battle(faction_key, waaagh_reward, attacker_value, defender_value, defender_multiplier, kill_ratio_defender);

				-- Check pooled resource for Advice trigger
				if faction:pooled_resource_manager():resource(self.pooled_resource):value() == 100 and faction:is_human() then
					core:trigger_event("ScriptEventWaghResourceMax")
				end
			
			end
		end
	end

	core:trigger_event("ScriptEventWaghBattle");

end

function waaagh:modify_pooled_resource(faction, factor, amount)
	cm:faction_add_pooled_resource(faction, self.pooled_resource, factor, amount);
end

function waaagh:print_battle(faction, waaagh_amount, aval, dval, bonus_mult, kill_ratio)
	waaagh_amount = tonumber(string.format("%.0f", waaagh_amount));
	out.design("--------------------------------------------");
	out.design("Waaagh Battle Fought");
	out.design("\tFaction: "..faction);
	out.design("\tWaaagh: "..waaagh_amount);
	out.design("\t\tAttacker Value: "..aval);
	out.design("\t\tDefender Value: "..dval);
	out.design("\t\tStrength Ratio: "..bonus_mult);
	out.design("\t\tKill Ratio: "..kill_ratio);
	out.design("--------------------------------------------");
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("waaagh_factions", waaagh.factions, context);
	end
);

cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			waaagh.factions = cm:load_named_value("waaagh_factions", waaagh.factions, context);
		end
	end
);