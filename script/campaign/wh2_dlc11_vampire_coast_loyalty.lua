local loyalty_trait = "wh2_dlc11_trait_incentive";
local loyalty_counter_trait = loyalty_trait .. "_counter";
local vampire_coast_subculture = "wh2_dlc11_sc_cst_vampire_coast";

local psychological_disorder_index = {"murderer", "looter", "arsonist", "smuggler", "schemer", "ringleader", "tech_leader", "tech_vigour", "tech_seacraft", "tech_renown"};

local psychological_disorder = {
	[psychological_disorder_index[1]] = {"wh2_dlc11_skill_innate_cst_murderer", "brute"},
	[psychological_disorder_index[2]] = {"wh2_dlc11_skill_innate_cst_looter", "brute"},
	[psychological_disorder_index[3]] = {"wh2_dlc11_skill_innate_cst_arsonist", "brute"},
	[psychological_disorder_index[4]] = {"wh2_dlc11_skill_innate_cst_smuggler", "mastermind"},
	[psychological_disorder_index[5]] = {"wh2_dlc11_skill_innate_cst_schemer", "mastermind"},
	[psychological_disorder_index[6]] = {"wh2_dlc11_skill_innate_cst_ringleader", "mastermind"},
	[psychological_disorder_index[7]] = {"wh2_dlc11_skill_cst_innate_admiral_tech_01", "mastermind"},
	[psychological_disorder_index[8]] = {"wh2_dlc11_skill_cst_innate_admiral_tech_02", "brute"},
	[psychological_disorder_index[9]] = {"wh2_dlc11_skill_cst_innate_admiral_tech_03", "mastermind"},
	[psychological_disorder_index[10]] = {"wh2_dlc11_skill_cst_innate_admiral_tech_04", "mastermind"}
};

local vampire_coast_lord_type = {
	"wh2_dlc11_cst_admiral_vampires",
	"wh2_dlc11_cst_admiral_death",
	"wh2_dlc11_cst_admiral_deep",
	"wh2_dlc11_cst_admiral_fem_vampires",
	"wh2_dlc11_cst_admiral_fem_death",
	"wh2_dlc11_cst_admiral_fem_deep"
};

local vampire_coast_tech_lord_type = {};

local loyalty_decline_rate = {
	["brute"] = 20, 
	["mastermind"] = 10
};

local loyalty_thresholds = {
	["high"] = 10,
	["mid_high"] = 8,
	["mid"] = 6,
	["mid_low"] = 4,
	["low"] = 2
};

local psychological_loyalty_change_rate = {
	["murderer"] = {
		["decline_rate"] = {loyalty_decline_rate["brute"], -1},
		["win_battle"] = {100, 1},
		["kill_general"] = {100, 1}
	},
	["looter"] = {
		["decline_rate"] = {loyalty_decline_rate["brute"], -1},
		["win_battle"] = {100, 1},
		["raid_stance"] = {50, 1},
		["sack_city"] = {100, 1}
	},
	["arsonist"] = {
		["decline_rate"] = {loyalty_decline_rate["brute"], -1},
		["win_battle"] = {100, 1},
		["raze_city"] = {100, 1},
		["win_siege_battle"] = {100, 1}
	},
	["smuggler"] = {
		["decline_rate"] = {loyalty_decline_rate["mastermind"], -1},
		["build_coves"] = {100, 2},
		["ask_ransom"] = {100, 1}
	},
	["schemer"] = {
		["decline_rate"] = {loyalty_decline_rate["mastermind"], -1},
		["ambush"] = {100, 2},
		["lightning"] = {100, 2}
	},
	["ringleader"] = {
		["decline_rate"] = {loyalty_decline_rate["mastermind"], -1},
		["recruit"] = {100, 1},
		["fight_with_reinforcement"] = {100, 1}
	},
	["tech_leader"] = {},
	["tech_vigour"] = {},
	["tech_seacraft"] = {},
	["tech_renown"] = {}
};

local loyalty_change_rate = {
	["post_battle_share"] = {100, 1},
	["post_siege_battle_share"] = {100, 1},
	["loyalty_rite"] = {50, 1}
};

function clear_and_set_trait(character, trait, counter_trait, num)
	if character:trait_points(counter_trait) ~= 0 then
		cm:force_add_trait(cm:char_lookup_str(character), trait, false, character:trait_points(counter_trait), false);
	elseif character:trait_points(trait) ~= 0 then
		cm:force_add_trait(cm:char_lookup_str(character), counter_trait, false, character:trait_points(trait), false);
	end;
	
	cm:force_add_trait(cm:char_lookup_str(character), trait, false, num);
end;

function update_trait(character)
	if background_check_vampire_coast_player_lord(character) or background_check_vampire_coast_player_techno_vikings(character) then
		local current_loyalty = character:loyalty();
		
		if current_loyalty <= loyalty_thresholds["low"] then
			clear_and_set_trait(character, loyalty_counter_trait, loyalty_trait, 2);
		elseif current_loyalty <= loyalty_thresholds["mid_low"] then
			clear_and_set_trait(character, loyalty_counter_trait, loyalty_trait, 1);
		elseif current_loyalty <= loyalty_thresholds["mid"]then
			clear_and_set_trait(character, loyalty_trait, loyalty_counter_trait, 1);
		elseif current_loyalty <= loyalty_thresholds["mid_high"] then
			clear_and_set_trait(character, loyalty_trait, loyalty_counter_trait, 2);
		elseif current_loyalty <= loyalty_thresholds["high"] then
			clear_and_set_trait(character, loyalty_trait, loyalty_counter_trait, 3);
		end;
	end;
end;

function background_check_vampire_coast_player_lord(character)
	if is_valid_vampire_coast_player_character(character) then
		for i = 1, #vampire_coast_lord_type do
			if character:character_subtype_key() == vampire_coast_lord_type[i] then
				return true;
			end;
		end;
	end;
end;

function background_check_vampire_coast_player_techno_vikings(character)
	if is_valid_vampire_coast_player_character(character) then
		for i = 1, #vampire_coast_lord_type do
			if character:character_subtype_key() == vampire_coast_tech_lord_type[i] then
				return true;
			end;
		end;
	end;
end;

function is_valid_vampire_coast_player_character(character)
	return not character:is_null_interface() and character:faction():is_human() and character:faction():subculture() == vampire_coast_subculture and cm:char_is_general_with_army(character) and not character:military_force():is_armed_citizenry();
end;

function modify_loyalty(character, points, possibility)
	-- increase character loyalty by points at possibility
	local previous_loyalty = character:loyalty();
	possibility = possibility or 100;
	
	if cm:random_number(100) <= possibility then
		out("modifying loyalty by "..points);
		cm:modify_character_personal_loyalty_factor(cm:char_lookup_str(character), points);
		update_trait(character);
	end;
	
	local new_loyalty = character:loyalty();
	
	if previous_loyalty > loyalty_thresholds["mid_low"] and new_loyalty <= loyalty_thresholds["mid_low"] then
		show_loyalty_change_message_event(character, "wh2_dlc11_event_feed_string_scripted_event_cst_loyalty_low_primary_detail", "wh2_dlc11_event_feed_string_scripted_event_cst_loyalty_low_secondary_detail", 1117);
	elseif previous_loyalty > loyalty_thresholds["low"] and new_loyalty <= loyalty_thresholds["low"] then
		show_loyalty_change_message_event(character, "wh2_dlc11_event_feed_string_scripted_event_cst_loyalty_critical_primary_detail", "wh2_dlc11_event_feed_string_scripted_event_cst_loyalty_critical_secondary_detail", 1115);
	elseif previous_loyalty <= loyalty_thresholds["high"] and new_loyalty > loyalty_thresholds["high"] then
		show_loyalty_change_message_event(character, "wh2_dlc11_event_feed_string_scripted_event_cst_loyalty_office_ready_primary_detail", "wh2_dlc11_event_feed_string_scripted_event_cst_loyalty_office_ready_secondary_detail", 1116);
	end;
end;

function show_loyalty_change_message_event(character, primary_detail, secondary_detail, id)
	cm:show_message_event_located(
		character:faction():name(),
		"event_feed_strings_text_wh2_dlc11_event_feed_string_scripted_event_cst_loyalty_title",
		"event_feed_strings_text_" .. primary_detail,
		"event_feed_strings_text_" .. secondary_detail,
		character:logical_position_x(),
		character:logical_position_y(),
		false,
		id
	);
end;

function return_psychological_disorder(character)
	for i = 1, #psychological_disorder_index do
		if character:has_skill(psychological_disorder[psychological_disorder_index[i]][1]) then
			local temp = psychological_disorder[psychological_disorder_index[i]];
			table.insert(temp, #temp + 1, psychological_disorder_index[i]);
			return temp;
		end;
	end;
end;

function modify_loyalty_on_event(character, event)
	local psychological_disorder = return_psychological_disorder(character);
	
	if psychological_loyalty_change_rate[psychological_disorder[3]][event] then
		modify_loyalty(character, psychological_loyalty_change_rate[psychological_disorder[3]][event][2], psychological_loyalty_change_rate[psychological_disorder[3]][event][1]);
	end
end

-- everyone gains trait when created
core:add_listener(
	"character_created_vmp_add_trait",
	"CharacterCreated",
	function(context)
		local character = context:character();
		return background_check_vampire_coast_player_lord(character) or background_check_vampire_coast_player_techno_vikings(character);
	end,
	function(context)
		update_trait(context:character());
	end,
	true
);

-- everyone loyalty decline
core:add_listener(
	"character_turn_start_vmp_modify_loyalty",
	"CharacterTurnStart",
	function(context)
		return background_check_vampire_coast_player_lord(context:character());
	end,
	function(context)
		local character = context:character();
		
		if character:faction():has_effect_bundle("wh2_dlc11_ritual_cst_eternal_service") then
			modify_loyalty(character, loyalty_change_rate["loyalty_rite"][2], loyalty_change_rate["loyalty_rite"][1]);
			out("loyalty decline declined by decline declining rite");
		elseif character:region():is_null_interface() ~= true and character:region():get_active_edict_key() == "wh2_dlc11_edict_cst_share_the_spoils" then
			out("loyalty decline declined by decline declining edict");
		elseif character:has_skill("wh2_dlc11_skill_cst_loyal_lord") then 
			out("loyalty decline declined by decline declining skill");
		elseif background_check_vampire_coast_player_techno_vikings(character) then
			out("loyalty decline declined by decline declining subtype");
		else
			modify_loyalty_on_event(character, "decline_rate");
		end;
	end,
	true
);

-- check post siege option
core:add_listener(
	"character_performs_settlement_occupation_decision_vmp_modify_loyalty",
	"CharacterPerformsSettlementOccupationDecision",
	true,
	function(context)
		local character = context:character();
		local occupation_decision = context:occupation_decision();
		
		-- check the occupation options
		if background_check_vampire_coast_player_lord(character) then
			if occupation_decision == "1256143616" then
				modify_loyalty_on_event(character, "raze_city");
			elseif occupation_decision == "615256079" then
				modify_loyalty_on_event(character, "build_coves");
			elseif occupation_decision == "1262847535" then
				modify_loyalty_on_event(character, "sack_city");
			elseif occupation_decision == "658757632" then
				modify_loyalty(character, loyalty_change_rate["post_siege_battle_share"][2], loyalty_change_rate["post_siege_battle_share"][1]);
			end;
		end;
		
		-- check techno vikings
		if background_check_vampire_coast_player_techno_vikings(character) and occupation_decision == "658757632" then
			modify_loyalty(character, loyalty_change_rate["post_siege_battle_share"][2], loyalty_change_rate["post_siege_battle_share"][1]);
		end;
	end,
	true
);

-- check post-battle loot option
core:add_listener(
	"character_post_battle_slaughter_vmp_modify_loyalty",
	"CharacterPostBattleCaptureOption",
	function(context)
		local character = context:character();
		
		return context:get_outcome_key() == "kill" and background_check_vampire_coast_player_lord(character) or background_check_vampire_coast_player_techno_vikings(character);
	end,
	function(context)
		modify_loyalty(context:character(), loyalty_change_rate["post_battle_share"][2], loyalty_change_rate["post_siege_battle_share"][1]);
	end,
	true
);

-- check raiding stance and recruit
core:add_listener(
	"character_turn_end_vmp_modify_loyalty",
	"CharacterTurnEnd",
	function(context)
		local character = context:character();
		
		return character:has_military_force() and not character:military_force():is_null_interface()
	end,
	function(context)
		local character = context:character();
		
		local stance = character:military_force():active_stance();
		
		if background_check_vampire_coast_player_lord(character) then
			if character:has_skill(psychological_disorder["looter"][1]) and (stance == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_LAND_RAID" or stance == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_SET_CAMP_RAIDING") then
				modify_loyalty_on_event(character, "raid_stance");
			elseif character:has_skill(psychological_disorder["ringleader"][1]) and stance == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_MUSTER" then
				modify_loyalty_on_event(character, "recruit");
			end;
		end;
	end,
	true
);

core:add_listener(
	"battle_completed_vmp_check_and_update_post_battle_traits",
	"BattleCompleted",
	true,
	function(context)
		local vampire_coast_lord = {
			["attacker"] = {},
			["defender"] = {}
		};
		
		local lord_wounded = {
			["attacker"] = false,
			["defender"] = false
		};
		
		if cm:pending_battle_cache_num_attackers() >= 1 then
			for i = 1, cm:pending_battle_cache_num_attackers() do
				local this_char_cqi, this_mf_cqi, current_faction_name = cm:pending_battle_cache_get_attacker(i);
				local character = cm:model():character_for_command_queue_index(this_char_cqi);
				
				if background_check_vampire_coast_player_lord(character) then
					table.insert(vampire_coast_lord["attacker"], this_char_cqi);
				end;
				
				if character:is_null_interface() or character:is_wounded() then
					lord_wounded["defender"] = true;
				end;
			end;
		end;
		
		if cm:pending_battle_cache_num_defenders() >= 1 then
			for i = 1, cm:pending_battle_cache_num_defenders() do
				local this_char_cqi, this_mf_cqi, current_faction_name = cm:pending_battle_cache_get_defender(i);
				local character = cm:model():character_for_command_queue_index(this_char_cqi);
				
				if background_check_vampire_coast_player_lord(character) then
					table.insert(vampire_coast_lord["defender"], this_char_cqi);
				end;
				
				if character:is_null_interface() or character:is_wounded() then
					lord_wounded["attacker"] = true;
				end;
			end;
		end;
		
		check_and_update_post_battle_traits(vampire_coast_lord["attacker"], lord_wounded["attacker"]);
		check_and_update_post_battle_traits(vampire_coast_lord["defender"], lord_wounded["defender"]);		
	end,
	true
);

function check_and_update_post_battle_traits(group, group_2)
	local pb = cm:model():pending_battle();
	
	for i, cqi in ipairs(group) do
		local character = cm:model():character_for_command_queue_index(cqi);
		
		if character:won_battle() then
			if character:has_skill(psychological_disorder["schemer"][1]) and pb:night_battle() then
				modify_loyalty_on_event(character, "lightning");
			end;
			
			if character:has_skill(psychological_disorder["schemer"][1]) and character:is_ambushing() then
				modify_loyalty_on_event(character, "ambush");
			end;
			
			if character:has_skill(psychological_disorder["ringleader"][1]) and #group > 1 then
				modify_loyalty_on_event(character, "fight_with_reinforcement");
			end;
			
			if character:has_skill(psychological_disorder["murderer"][1]) and group_2 then
				modify_loyalty_on_event(character, "kill_general");
			end;
			
			if character:has_skill(psychological_disorder["arsonist"][1]) and pb:siege_battle() then
				modify_loyalty_on_event(character, "win_siege_battle");
			end;
			
			if return_psychological_disorder(character)[2] == "brute" then
				modify_loyalty_on_event(character, "win_battle");
			end;
		end;
	end;
end;