local dwarf_faction_key = "wh3_main_dwf_the_ancestral_throng";
local god_choice_dilemma_prefix = "wh_pro01_dwf_grombrindal_god_choice_";
local god_choice_last_god = "white_dwarf";
local god_choice_skill_key = "wh_pro01_skill_dwf_lord_unique_grombrindal_dilemma";
local god_choice_first_event = 3;
local turns_until_event = 25;

function add_grombrindal_listeners()
	
	if cm:get_faction(dwarf_faction_key):is_human() then
		cm:add_faction_turn_start_listener_by_name(
			"Grombrindal_FactionTurnStart",
			dwarf_faction_key,
			function(context)
				local turn = cm:model():turn_number();
				turns_until_event = turns_until_event - 1;
				
				if turns_until_event <= 0 then
					trigger_god_choice();
					return;
				elseif turn == god_choice_first_event then -- first time the event triggers (turn 3)
					trigger_god_choice();
				end;
			end,
			true
		);
		
		core:add_listener(
			"Grombrindal_DilemmaChoiceMadeEvent",
			"DilemmaChoiceMadeEvent",
			function(context)
				return context:dilemma():starts_with(god_choice_dilemma_prefix);
			end,
			function(context)
				local choice = context:choice();
				
				if choice == 0 then
					god_choice_last_god = "grimnir";
				elseif choice == 1 then
					god_choice_last_god = "valaya";
				elseif choice == 2 then
					god_choice_last_god = "grungni";
				else
					god_choice_last_god = "white_dwarf";
				end;
				
				cm:remove_effect_bundle("wh_pro01_bundle_god_choice_none", dwarf_faction_key);
				give_grombrindal_effect();
			end,
			true
		);

		cm:add_faction_turn_start_listener_by_name(
			"Grombrindal_CharacterTurnStart",
			dwarf_faction_key,
			give_grombrindal_effect,
			true
		);
		
		core:add_listener(
			"Grombrindal_CharacterSkillPointAllocated",
			"CharacterSkillPointAllocated",
			function(context)
				return context:skill_point_spent_on() == god_choice_skill_key;
			end,
			function(context)
				remove_all_faction_god_bundles();
				
				turns_until_event = turns_until_event - 10;
				
				cm:apply_effect_bundle("wh_pro01_bundle_god_choice_" .. god_choice_last_god, dwarf_faction_key, turns_until_event);
				
				if turns_until_event <= 0 then
					trigger_god_choice();
				end;
			end,
			true
		);
		
		if cm:is_new_game() then
			cm:apply_effect_bundle("wh_pro01_bundle_god_choice_none", dwarf_faction_key, god_choice_first_event);
		end;
	end;
end;

function remove_all_faction_god_bundles()
	local bundles = {
		"wh_pro01_bundle_god_choice_none",
		"wh_pro01_bundle_god_choice_grimnir",
		"wh_pro01_bundle_god_choice_grungni",
		"wh_pro01_bundle_god_choice_valaya",
		"wh_pro01_bundle_god_choice_white_dwarf"
	};
	
	for i = 1, #bundles do
		cm:remove_effect_bundle(bundles[i], dwarf_faction_key);
	end;
end;

function trigger_god_choice()
	remove_all_faction_god_bundles();
	cm:apply_effect_bundle("wh_pro01_bundle_god_choice_none", dwarf_faction_key, 0);
	
	-- reset the timer 
	turns_until_event = 25;
	
	local grombrindal = get_grombrindal();
	
	if grombrindal then
		if grombrindal:has_skill(god_choice_skill_key) then
			turns_until_event = 15;
		end;
	end;
	
	local dilemma = god_choice_dilemma_prefix .. god_choice_last_god .. "_" .. tostring(turns_until_event);
	
	out("GOD DILEMMA - Triggering God Dilemma [" .. dilemma .. "]");
	cm:trigger_dilemma(dwarf_faction_key, dilemma);
end;

function give_grombrindal_effect()
	local effect = "wh_pro01_bundle_god_choice_" .. god_choice_last_god .. "_force";
	
	if god_choice_last_god ~= "none" and cm:model():turn_number() > 2 then
		local character = get_grombrindal();
		
		local faction = cm:get_faction(dwarf_faction_key);
		
		if faction and character then
			local cqi = character:command_queue_index();
			
			local bundles = {
				"wh_pro01_bundle_god_choice_grimnir_force",
				"wh_pro01_bundle_god_choice_grungni_force",
				"wh_pro01_bundle_god_choice_valaya_force",
				"wh_pro01_bundle_god_choice_white_dwarf_force"
			};
			
			for i = 1, #bundles do
				cm:remove_effect_bundle_from_characters_force(bundles[i], cqi);
			end;
			
			if character:get_forename() == "names_name_2147358917" and character:has_military_force() then
				cm:apply_effect_bundle_to_characters_force(effect, cqi, 0);
			end;
		end;
	end;
end;

function get_grombrindal()
	local faction = cm:get_faction(dwarf_faction_key);
	
	if faction then
		local character_list = faction:character_list();
		
		for i = 0, character_list:num_items() - 1 do
			local current_char = character_list:item_at(i);
			
			if current_char:get_forename() == "names_name_2147358917" then
				return current_char;
			end;
		end;
	end;
end;

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("GOD_CHOICE_LAST_GOD", god_choice_last_god, context);
		cm:save_named_value("turns_until_event", turns_until_event, context);
	end
);

cm:add_loading_game_callback(
	function(context)
		god_choice_last_god = cm:load_named_value("GOD_CHOICE_LAST_GOD", "none", context);
		turns_until_event = cm:load_named_value("turns_until_event", 25, context);
	end
);