local devotion_amount_declare_war_on_kislev = -100;

local devotion_incursion_turn_cooldown = 10;

local follower_thresholds = {
	[0] = {follower_threshold = 50, effect_bundle_key = "wh3_main_bundle_ksl_followers_1", completed = false, winner = ""},
	[1] = {follower_threshold = 100, effect_bundle_key = "wh3_main_bundle_ksl_followers_2", completed = false, winner = ""},
	[2] = {follower_threshold = 200, effect_bundle_key = "wh3_main_bundle_ksl_followers_3", completed = false, winner = ""},
	[3] = {follower_threshold = 400, effect_bundle_key = "wh3_main_bundle_ksl_followers_4", completed = false, winner = ""},
	[4] = {follower_threshold = 600, effect_bundle_key = "wh3_main_bundle_ksl_followers_5", completed = false, winner = ""}
}
local ai_follower_multiplier = 2
local current_winner = ""

function setup_kislev_devotion()
	-- initialise incursion chance ui state for each human kislev faction
	local human_factions = cm:get_human_factions();
	
	for i = 1, #human_factions do
		if has_devotion_pooled_resource(cm:get_faction(human_factions[i])) then
			common.set_context_value("devotion_incursion_chance_ui_state_" .. human_factions[i], cm:get_saved_value("devotion_incursion_chance_ui_state_" .. human_factions[i]) or 0);
		end;
	end;
	
	local function attempt_to_spawn_chaos_incursion(faction, severity)
		local faction_key = faction:name();
		
		if cm:model():turn_number() > 2 and not cm:get_saved_value("devotion_incursion_unavailable_" .. faction_key) and faction:has_home_region() then
			local size = 19;
			local chance = 25;
			
			if severity == 2 then
				chance = 15;
				size = 12;
			elseif severity == 1 then
				chance = 5;
				size = 5;
			end;
			
			if cm:random_number(100) <= chance then
				local target_region = faction:home_region();
				
				-- get the closest settlement to the faction leader
				if faction:has_faction_leader() then
					local faction_leader = faction:faction_leader();
					
					if faction_leader:has_military_force() then
						local closest_distance = 500000;
						local faction_leader_x = faction_leader:logical_position_x();
						local faction_leader_y = faction_leader:logical_position_y();
						
						local region_list = faction:region_list();
						
						for i = 0, region_list:num_items() - 1 do
							local current_region = region_list:item_at(i);
							local current_settlement = current_region:settlement();
							
							local current_settlement_distance = distance_squared(faction_leader_x, faction_leader_y, current_settlement:logical_position_x(), current_settlement:logical_position_y());
							
							if current_settlement_distance < closest_distance then
								closest_distance = current_settlement_distance;
								target_region = current_region;
							end;
						end;
					end;
				end;
				
				-- only allow one spawn every so many turns
				cm:add_turn_countdown_event(faction_key, devotion_incursion_turn_cooldown, "ScriptEventKislevDevotionChaosIncursionAvailable", faction_key);
				cm:set_saved_value("devotion_incursion_unavailable_" .. faction_key, true);
				
				-- select a rebel faction based on the severity of the incursion
				local rebel_factions = {
					"wh_main_nor_norsca_rebels",
					"wh_main_chs_chaos_rebels",
					"wh_dlc03_bst_beastmen_rebels",
					"wh3_main_kho_khorne_rebels",
					"wh3_main_nur_nurgle_rebels",
					"wh3_main_sla_slaanesh_rebels",
					"wh3_main_tze_tzeentch_rebels"
				};
				
				local chosen_rebel_faction = "";
				
				if severity == 1 then
					chosen_rebel_faction = rebel_factions[1];
				elseif severity == 2 then
					chosen_rebel_faction = rebel_factions[cm:random_number(3, 2)];
				else
					chosen_rebel_faction = rebel_factions[cm:random_number(7, 4)];
				end;
				
				cm:disable_event_feed_events(true, "", "", "provinces_unrest_rebellion");
				cm:force_rebellion_with_faction(target_region, chosen_rebel_faction, size, false, true);
				cm:disable_event_feed_events(false, "", "", "provinces_unrest_rebellion");
				
				-- Trigger event with the faction as context.
				core:trigger_event("ScriptEventChaosIncursionAgainstFaction", faction)

				cm:trigger_incident_with_targets(faction:command_queue_index(), "wh3_main_incident_ksl_chaos_incursion", 0, 0, 0, 0, target_region:cqi(), target_region:settlement():cqi());
			end;
		end;
	end;
	
	-- reset the incursion turn cooldown
	core:add_listener(
		"reset_devotion_incursion_cooldown",
		"ScriptEventKislevDevotionChaosIncursionAvailable",
		true,
		function(context)
			cm:set_saved_value("devotion_incursion_unavailable_" .. context.string, false);
		end,
		true
	);
	
	core:add_listener(
		"set_devotion_incursion_chance",
		"FactionTurnStart",
		function(context)
			local faction = context:faction();
			return has_devotion_pooled_resource(faction);
		end,
		function(context)
			local faction = context:faction()
			local faction_key = faction:name()
			local effect_bundle = "wh3_dlc24_climate_uninhabitable_chaotic_anti"
			
			-- the chaotic climate for boris is unsuitable rather than uninhabitable, so he gets a different effect bundle to counter those effects
			if faction_key == "wh3_main_ksl_ursun_revivalists" then
				effect_bundle = "wh3_dlc24_climate_unsuitable_chaotic_anti"
			end
			
			-- counter climate effects when commandment is active
			for _, region in model_pairs(faction:region_list()) do
				local has_effect_bundle = region:has_effect_bundle(effect_bundle)
				
				if region:get_active_edict_key() == "wh3_dlc24_edict_ksl_anti_chaos" then
					if region:settlement():get_climate() == "climate_chaotic" and not has_effect_bundle then
						cm:apply_effect_bundle_to_region(effect_bundle, region:name(), -1)
					end
				elseif has_effect_bundle then
					cm:remove_effect_bundle_from_region(effect_bundle, region:name())
				end
			end
			
			-- force chaos rebellions if a human kislev faction has a low level of devotion
			if faction:is_human() then
				local devotion_value = faction:pooled_resource_manager():resource("wh3_main_ksl_devotion"):value();
				local incursion_chance = cm:get_saved_value("devotion_incursion_chance_" .. faction_key) or 0;
				
				-- tick up the chance of incursion each turn
				if devotion_value < 0 then
					incursion_chance = incursion_chance + 1;
				else
					incursion_chance = 0;
				end;
				
				local devotion_incursion_chance_ui_state = 0;
				
				if incursion_chance > 15 then
					attempt_to_spawn_chaos_incursion(faction, 3);
					devotion_incursion_chance_ui_state = 3;
				elseif incursion_chance > 5 then
					attempt_to_spawn_chaos_incursion(faction, 2);
					devotion_incursion_chance_ui_state = 2;
				elseif incursion_chance > 0 then
					attempt_to_spawn_chaos_incursion(faction, 1);
					devotion_incursion_chance_ui_state = 1;
				end;
				
				cm:set_saved_value("devotion_incursion_chance_" .. faction_key, incursion_chance)
				cm:set_saved_value("devotion_incursion_chance_ui_state_" .. faction_key, devotion_incursion_chance_ui_state)
				common.set_context_value("devotion_incursion_chance_ui_state_" .. faction_key, devotion_incursion_chance_ui_state);
			end;
		end,
		true
	);
	
	core:add_listener(
		"kislev_declares_war_on_kislev",
		"NegativeDiplomaticEvent",
		function(context)
			local proposer = context:proposer();
			return proposer:is_human() and has_devotion_pooled_resource(proposer) and context:recipient():culture() == "wh3_main_ksl_kislev" and context:is_war();
		end,
		function(context)
			cm:faction_add_pooled_resource(context:proposer():name(), "wh3_main_ksl_devotion", "declared_war_on_kislev", devotion_amount_declare_war_on_kislev);
		end,
		true
	);
	
	local function was_action_success(context)
		return context:ability() ~= "assist_army" and (context:mission_result_critial_success() or context:mission_result_success());
	end;
	
	local function add_devotion(character)
		local character_subtype = character:character_subtype_key();
		local faction = character:faction();
		local devotion_to_add = 0;
		
		local devotion_hero_actions_frost_maiden = faction:bonus_values():scripted_value("devotion_hero_actions_frost_maiden", "value");
		local devotion_hero_actions_patriarch = faction:bonus_values():scripted_value("devotion_hero_actions_patriarch", "value");
		--local devotion_hero_actions_hag_witch = faction:bonus_values():scripted_value("devotion_hero_actions_hag_witch", "value");
		
		if devotion_hero_actions_frost_maiden > 0 and character_subtype:find("wh3_main_ksl_frost_maiden") then
			devotion_to_add = devotion_hero_actions_frost_maiden;
		elseif devotion_hero_actions_patriarch > 0 and character_subtype == "wh3_main_ksl_patriarch" then
			devotion_to_add = devotion_hero_actions_patriarch;
		--elseif devotion_hero_actions_hag_witch > 0 and character_subtype:find("wh3_dlc24_ksl_hag_witch") then
			--devotion_to_add = devotion_hero_actions_hag_witch;
		end;
		
		if devotion_to_add > 0 then
			local mod = 1 + (faction:bonus_values():scripted_value("devotion_hero_actions_modifier", "value") / 100) + (character:bonus_values():scripted_value("devotion_hero_actions_modifier", "value") / 100);
			cm:faction_add_pooled_resource(faction:name(), "wh3_main_ksl_devotion", "hero_actions", devotion_to_add * mod);
		end;
	end;
	
	core:add_listener(
		"kislev_hero_targets_character",
		"CharacterCharacterTargetAction",
		function(context)
			return was_action_success(context);
		end,
		function(context)
			add_devotion(context:character());
		end,
		true
	);
	
	core:add_listener(
		"kislev_hero_targets_garrison",
		"CharacterGarrisonTargetAction",
		function(context)
			return was_action_success(context);
		end,
		function(context)
			add_devotion(context:character());
		end,
		true
	);

	-- Follower related functionality
	
	-- Function to check follower states
	function check_followers()
		local faction_katarin = cm:get_faction("wh3_main_ksl_the_ice_court")
		local faction_kostaltyn = cm:get_faction("wh3_main_ksl_the_great_orthodoxy")
		local followers_katarin = faction_katarin:pooled_resource_manager():resource("wh3_main_ksl_followers"):value()
		local followers_kostaltyn = faction_kostaltyn:pooled_resource_manager():resource("wh3_main_ksl_followers"):value()
		local title_katarin = "event_feed_strings_text_wh3_main_event_feed_scripted_event_followers_katarin_wins_title"
		local description_katarin = "event_feed_strings_text_wh3_main_event_feed_scripted_event_followers_katarin_wins_description"
		local title_kostaltyn = "event_feed_strings_text_wh3_main_event_feed_scripted_event_followers_kostaltyn_wins_title"
		local description_kostaltyn = "event_feed_strings_text_wh3_main_event_feed_scripted_event_followers_kostaltyn_wins_description"

		--[[
		for index, thresholds in pairs(follower_thresholds) do
			if thresholds.completed == false then
				if followers_katarin >= thresholds.follower_threshold then
					effect_bundle_update(index, faction_katarin:name(), current_winner)
					thresholds.completed = true;
					thresholds.winner = faction_katarin:name();
					current_winner = faction_katarin:name();
										
					if indexx == 4 then
						local title_katarin = "wh3_main_event_feed_scripted_event_followers_katarin_final_title"
						local description_katarin = "wh3_main_event_feed_scripted_event_followers_katarin_final_description"
						force_confederation(faction_katarin, faction_kostaltyn)
					end
					
					trigger_event(title_katarin, description_katarin)
				elseif followers_kostaltyn >= thresholds.follower_threshold then
					effect_bundle_update(index, faction_kostaltyn:name(), current_winner)
					thresholds.completed = true;
					thresholds.winner = faction_kostaltyn:name();
					current_winner = faction_kostaltyn:name();

					if indexx == 4 then
						local title_kostaltyn = "wh3_main_event_feed_scripted_event_followers_kostaltyn_final_title"
						local description_kostaltyn = "wh3_main_event_feed_scripted_event_followers_kostaltyn_final_description"
						force_confederation(faction_katarin, faction_kostaltyn)
					end

					trigger_event(title_kostaltyn, description_kostaltyn)
				end
			end
		end
		]]--

		if follower_thresholds[0].completed == false then
			if followers_katarin >= follower_thresholds[0].follower_threshold then
				cm:apply_effect_bundle(follower_thresholds[0].effect_bundle_key, faction_katarin:name(), 0);
				follower_thresholds[0].completed = true;
				follower_thresholds[0].winner = faction_katarin:name();
				current_winner = faction_katarin:name()
				trigger_event(title_katarin, description_katarin)
			elseif followers_kostaltyn >= follower_thresholds[0].follower_threshold then
				cm:apply_effect_bundle(follower_thresholds[0].effect_bundle_key, faction_kostaltyn:name(), 0);
				follower_thresholds[0].completed = true;
				follower_thresholds[0].winner = faction_kostaltyn:name();
				current_winner = faction_kostaltyn:name()
				trigger_event(title_kostaltyn, description_kostaltyn)
			end
		end	
		if follower_thresholds[1].completed == false and follower_thresholds[0].completed == true then
			if followers_katarin >= follower_thresholds[1].follower_threshold then
				effect_bundle_update(1, faction_katarin:name(), current_winner)
				follower_thresholds[1].completed = true;
				follower_thresholds[1].winner = faction_katarin:name();
				current_winner = faction_katarin:name()
				trigger_event(title_katarin, description_katarin)
			elseif followers_kostaltyn >= follower_thresholds[1].follower_threshold then
				effect_bundle_update(1, faction_kostaltyn:name(), current_winner)
				follower_thresholds[1].completed = true;
				follower_thresholds[1].winner = faction_kostaltyn:name();
				current_winner = faction_kostaltyn:name()
				trigger_event(title_kostaltyn, description_kostaltyn)
			end
		end	
		if follower_thresholds[2].completed == false and follower_thresholds[1].completed == true then
			if followers_katarin >= follower_thresholds[2].follower_threshold then
				effect_bundle_update(2, faction_katarin:name(), current_winner)
				follower_thresholds[2].completed = true;
				follower_thresholds[2].winner = faction_katarin:name();
				current_winner = faction_katarin:name()
				trigger_event(title_katarin, description_katarin)
			elseif followers_kostaltyn >= follower_thresholds[2].follower_threshold then
				effect_bundle_update(2, faction_kostaltyn:name(), current_winner)
				follower_thresholds[2].completed = true;
				follower_thresholds[2].winner = faction_kostaltyn:name();
				current_winner = faction_kostaltyn:name()
				trigger_event(title_kostaltyn, description_kostaltyn)
			end
		end	
		if follower_thresholds[3].completed == false and follower_thresholds[2].completed == true  then
			if followers_katarin >= follower_thresholds[3].follower_threshold then
				effect_bundle_update(3, faction_katarin:name(), current_winner)
				follower_thresholds[3].completed = true;
				follower_thresholds[3].winner = faction_katarin:name();
				current_winner = faction_katarin:name()
				trigger_event(title_katarin, description_katarin)
			elseif followers_kostaltyn >= follower_thresholds[3].follower_threshold then
				effect_bundle_update(3, faction_kostaltyn:name(), current_winner)
				follower_thresholds[3].completed = true;
				follower_thresholds[3].winner = faction_kostaltyn:name();
				current_winner = faction_kostaltyn:name()
				trigger_event(title_kostaltyn, description_kostaltyn)
			end
		end	
		if follower_thresholds[4].completed == false and follower_thresholds[3].completed == true   then
			if followers_katarin >= follower_thresholds[4].follower_threshold then
				effect_bundle_update(4, faction_katarin:name(), current_winner)
				follower_thresholds[4].completed = true;
				follower_thresholds[4].winner = faction_katarin:name();
				current_winner = faction_katarin:name()

				if cm:is_multiplayer() == false or faction_kostaltyn:is_human() == false then
					trigger_final_supporters_dilemma(current_winner, faction_kostaltyn:name(), "wh3_main_ksl_dilemma_supporters_katarin")
				end
			elseif followers_kostaltyn >= follower_thresholds[4].follower_threshold then
				effect_bundle_update(4, faction_kostaltyn:name(), current_winner)
				follower_thresholds[4].completed = true;
				follower_thresholds[4].winner = faction_kostaltyn:name();
				current_winner = faction_kostaltyn:name()

				if cm:is_multiplayer() == false or faction_katarin:is_human() == false then
					trigger_final_supporters_dilemma(current_winner, faction_katarin:name(), "wh3_main_ksl_dilemma_supporters_kostaltyn")
				end
			end
		end	
	end

	-- Function to trigger event
	function trigger_event(title, description)
		local human_factions = cm:get_human_factions();
		
		for i = 1, #human_factions do
			if human_factions[i] == "wh3_main_ksl_the_ice_court" or human_factions[i] == "wh3_main_ksl_the_great_orthodoxy" then
				cm:show_message_event(
					human_factions[i],
					title,
					"",
					description,
					true,
					1312
				);
			end
		end
	end

	-- Function to update the effect_bundle
	function effect_bundle_update(x, faction1, faction2)
		cm:apply_effect_bundle(follower_thresholds[x].effect_bundle_key, faction1, 0);
		cm:remove_effect_bundle(follower_thresholds[x-1].effect_bundle_key, faction2)
	end

	-- Function to add followers
	function add_followers(faction, amount)
		local faction_name = faction:name()
		local followers = amount
		local followers_ai = amount * ai_follower_multiplier

		if faction:pooled_resource_manager():resource("wh3_main_ksl_followers") then
			if faction:is_human() then
				cm:faction_add_pooled_resource(faction_name, "wh3_main_ksl_followers", "invoking_the_motherland", followers);
			else
				cm:faction_add_pooled_resource(faction_name, "wh3_main_ksl_followers", "invoking_the_motherland", followers_ai);
			end
		end
	end;

	-- Function to check if invocation of the motherland is ongoing
	function check_invocations(faction, ritual)
		if faction:has_rituals() then
			local active_rituals = faction:rituals():active_rituals()
			
			for i = 0, active_rituals:num_items() - 1 do
				local current_active_ritual = active_rituals:item_at(i):ritual_key();
				
				if current_active_ritual == ritual or current_active_ritual == ritual .. "_upgraded" then
					return true
				end;
			end;
		end;
	end;

	-- Function to set winners for UI
	function check_winners()
		common.set_context_value("follower_threshold_1", follower_thresholds[0].winner)
		common.set_context_value("follower_threshold_2", follower_thresholds[1].winner)
		common.set_context_value("follower_threshold_3", follower_thresholds[2].winner)
		common.set_context_value("follower_threshold_4", follower_thresholds[3].winner)
		common.set_context_value("follower_threshold_5", follower_thresholds[4].winner)
	end

	-- Listeners
	core:add_listener(
		"follower_turnstart_check",
		"FactionTurnStart",
		function(context)
			local faction = context:faction();
			return has_supporters_pooled_resource(faction) and faction:can_be_human();
		end,
		function(context)
			local faction = context:faction();
			local faction_name = faction:name();
			
			-- add the saved value from dazh invocation
			local pending_save_value = cm:get_saved_value("followers_to_add_" .. faction_name) or 0
			if pending_save_value > 0 then
				add_followers(faction, pending_save_value)
				cm:set_saved_value("followers_to_add_" .. faction_name, 0)
			end
			
			check_followers()
			check_winners()

			if faction_name == "wh3_main_ksl_the_great_orthodoxy" and not faction:is_human() then 
				cm:faction_add_pooled_resource(faction_name, "wh3_main_ksl_followers", "events", 2);
			end
		end,
		true
	);

	-- Dazh : Construct a building
	core:add_listener(
		"follower_invocation_building_completed",
		"BuildingCompleted",
		function(context)
			return check_invocations(context:building():faction(), "wh3_main_ritual_ksl_winter_dazh");
		end,
		function(context)
			-- cache this value as buildings complete at end of round, so to display the pooled resource change in the UI, add it at the start of their turn instead
			local save_value = "followers_to_add_" .. context:building():faction():name()
			local amount_to_add = cm:get_saved_value(save_value) or 0
			cm:set_saved_value(save_value, amount_to_add + 1) -- increment the value as this event can fire multiple times before the next turn
		end,
		true
	);

	-- Ursun : Occupy a settlement
	core:add_listener(
		"follower_invocation_settlement_occupied",
		"GarrisonOccupiedEvent",
		function(context)
			return check_invocations(context:character():faction(), "wh3_main_ritual_ksl_winter_ursun");
		end,
		function(context)
			add_followers(context:character():faction(), 5);
			check_followers()
			check_winners()
		end,
		true
	);

	-- Salyak : Gain a character level
	core:add_listener(
		"follower_invocation_character_rankup",
		"CharacterRankUp",
		function(context)
			return check_invocations(context:character():faction(), "wh3_main_ritual_ksl_winter_salyak");
		end,
		function(context)
			add_followers(context:character():faction(), 1);
			check_followers()
			check_winners()
		end,
		true
	);

	-- Tor : Fight a battle
	core:add_listener(
		"follower_invocation_battle",
		"BattleCompleted",
		function()
			return cm:model():pending_battle():has_been_fought();
		end,
		function()
			local followers_added = false;
			
			for i = 1, cm:pending_battle_cache_num_attackers() do
				local char_cqi, mf_cqi, faction_name = cm:pending_battle_cache_get_attacker(i);
				local attacker_faction = cm:get_faction(faction_name);
				
				if attacker_faction and check_invocations(attacker_faction, "wh3_main_ritual_ksl_winter_tor") then
					add_followers(attacker_faction, 2);
					followers_added = true;
				end
			end
			
			for i = 1, cm:pending_battle_cache_num_defenders() do
				local char_cqi, mf_cqi, faction_name = cm:pending_battle_cache_get_defender(i);
				local defender_faction = cm:get_faction(faction_name);
				
				if defender_faction and check_invocations(defender_faction, "wh3_main_ritual_ksl_winter_tor") then
					add_followers(defender_faction, 2);
					followers_added = true;
				end
			end
			
			if followers_added then
				check_followers()
				check_winners()
			end;
		end,
		true
	);
end;

function has_devotion_pooled_resource(faction)
	return not faction:pooled_resource_manager():resource("wh3_main_ksl_devotion"):is_null_interface()
end

function has_supporters_pooled_resource(faction)
	return not faction:pooled_resource_manager():resource("wh3_main_ksl_followers"):is_null_interface()
end

function trigger_final_supporters_dilemma(winner, loser, dilemma)
	-- allow war again as the race is over
	cm:force_diplomacy("faction:wh3_main_ksl_the_ice_court", "faction:wh3_main_ksl_the_great_orthodoxy", "war", true, true, true)
	
	if cm:get_faction(loser):is_human() then
		cm:apply_effect_bundle("wh3_main_ksl_reward_ai_motherland_victory", winner, 0)
	else
		cm:trigger_dilemma(winner, dilemma)
		
		core:add_listener(
			"final_supporters_dilemma_choice",
			"DilemmaChoiceMadeEvent",
			function(context)
				return context:dilemma() == dilemma
			end,
			function(context)
				local choice = context:choice()
				
				if choice == 0 then
					cm:force_confederation(winner, loser)
				elseif choice == 1 then
					cm:force_alliance(winner, loser, true)
				else
					cm:force_declare_war(winner, loser, false, false)
				end
			end,
			false
		)
	end
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("follower_thresholds", follower_thresholds, context);
		cm:save_named_value("current_winner", current_winner, context);
	end
);

cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			follower_thresholds = cm:load_named_value("follower_thresholds", follower_thresholds, context);
			current_winner = cm:load_named_value("current_winner", current_winner, context);
		end
	end
);