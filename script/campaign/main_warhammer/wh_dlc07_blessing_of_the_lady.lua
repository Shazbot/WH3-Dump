BLESSING_EFFECT_KEY = "wh_dlc07_blessing_of_the_lady";
BLESSING_CURRENT_ARMIES = {};
BLESSING_RESULT_CHANCES = {
	["heroic_victory"] = 100,
	["decisive_victory"] = 20,
	["close_victory"] = 10,
	["pyrrhic_victory"] = 0
};

function Add_Lady_Blessing_Listeners()
	out("#### Adding Lady Blessing Listeners ####");
	core:add_listener(
		"Blessing_BattleCompleted",
		"BattleCompleted",
		true,
		function(context) Blessing_BattleCompleted(context) end,
		true
	);
	core:add_listener(
		"Blessing_CharacterWithdrewFromBattle",
		"CharacterWithdrewFromBattle",
		function(context)
			local character = context:character();
			local pb = cm:model():pending_battle();
			
			return not character:is_null_interface() and character:faction():culture() == "wh_main_brt_bretonnia" and character:has_military_force() and not (pb:has_attacker() and pb:attacker() == character and character:has_garrison_residence());
		end,
		function(context) Blessing_Character_Retreated(context:character()) end,
		true
	);
end

function Blessing_BattleCompleted(context)
	local num_attackers = cm:pending_battle_cache_num_attackers();
	local num_defenders = cm:pending_battle_cache_num_defenders();
	
	if num_attackers < 1 or num_defenders < 1 then
		return false;
	end
	
	local attacker_cqi, attacker_force_cqi, attacker_name = cm:pending_battle_cache_get_attacker(1);
	local defender_cqi, defender_force_cqi, defender_name = cm:pending_battle_cache_get_defender(1);
	local attacker = cm:get_faction(attacker_name)
	local attacker_is_bretonnian = attacker and attacker:culture() == "wh_main_brt_bretonnia"
	local defender = cm:get_faction(defender_name)
	local defender_is_bretonnian = defender and defender:culture() == "wh_main_brt_bretonnia"
	
	if attacker_is_bretonnian or defender_is_bretonnian then
		local attacker_result = cm:model():pending_battle():attacker_battle_result();
		local defender_result = cm:model():pending_battle():defender_battle_result();
		
		if attacker_result == "close_defeat" and defender_result == "close_defeat" then
			-- They've both had a close defeat, must have been a retreat not a battle!
			return;
		elseif attacker_result == nil or defender_result == nil then
			return;
		end
		
		if cm:model():pending_battle():has_attacker() and cm:model():pending_battle():attacker():is_null_interface() == false and attacker_is_bretonnian and (attacker:is_null_interface() == false and attacker:is_human()) then
			local chance = BLESSING_RESULT_CHANCES[attacker_result] or 0;
			
			if cm:model():random_percent(chance) then
				Blessing_Character_Won(cm:model():pending_battle():attacker());
			end
		end
		
		if cm:model():pending_battle():has_defender() and cm:model():pending_battle():defender():is_null_interface() == false and defender_is_bretonnian and (defender:is_null_interface() == false and defender:is_human()) then
			local chance = BLESSING_RESULT_CHANCES[defender_result] or 0;
			
			if cm:model():random_percent(chance) then
				Blessing_Character_Won(cm:model():pending_battle():defender());
			end
		end
	end
end

-- Blessing Lost
function Blessing_Character_Retreated(character)
	local force_cqi = character:military_force():command_queue_index();
	
	if character:faction():is_human() and Has_Blessing_Already(force_cqi) then
		core:trigger_event("ScriptEventRemoveBlessing");
		Show_Blessing_Lost_Event(character);
	end;
	
	Remove_Blessing(force_cqi);
	cm:remove_character_vfx(character:command_queue_index(), "scripted_effect");
end

-- Blessing Gained
function Blessing_Character_Won(character)
	if character:is_null_interface() == false and character:faction():culture() == "wh_main_brt_bretonnia" then
		if character:has_military_force() then
			local force_cqi = character:military_force():command_queue_index();
			
			if Has_Blessing_Already(force_cqi) ~= true and character:military_force():is_armed_citizenry() == false then
				Add_Blessing(force_cqi);
				local show_in_shroud = false;
				cm:add_character_vfx(character:command_queue_index(), "scripted_effect", show_in_shroud);
				
				if character:faction():is_human() then
					core:trigger_event("ScriptEventAddBlessing");
					Show_Blessing_Gained_Event(character);
				end
			end
		end
	end
end

function Has_Blessing_Already(force_cqi)
	for i = 1, #BLESSING_CURRENT_ARMIES do
		if BLESSING_CURRENT_ARMIES[i] == force_cqi then
			return true;
		end
	end
	return false;
end

function Add_Blessing(force_cqi)
	cm:remove_effect_bundle_from_force(BLESSING_EFFECT_KEY, force_cqi);
	cm:apply_effect_bundle_to_force(BLESSING_EFFECT_KEY, force_cqi, 0);
	table.insert(BLESSING_CURRENT_ARMIES, force_cqi);
end

function Remove_Blessing(force_cqi)
	cm:remove_effect_bundle_from_force(BLESSING_EFFECT_KEY, force_cqi);
	
	for i = 1, #BLESSING_CURRENT_ARMIES do
		if BLESSING_CURRENT_ARMIES[i] == force_cqi then
			table.remove(BLESSING_CURRENT_ARMIES, i);
		end
	end
end

function Show_Blessing_Gained_Event(character)
	if character:is_null_interface() == false then
		local force_X = character:logical_position_x();
		local force_Y = character:logical_position_y();
		
		cm:show_message_event_located(
			character:faction():name(),
			"event_feed_strings_text_wh_dlc07_event_feed_string_scripted_event_blessing_gained_title",
			"event_feed_strings_text_wh_dlc07_event_feed_string_scripted_event_blessing_gained_primary_detail",
			"event_feed_strings_text_wh_dlc07_event_feed_string_scripted_event_blessing_gained_secondary_detail",
			force_X,
			force_Y,
			false,
			710
		);
	end
end

function Show_Blessing_Lost_Event(character)
	if character:is_null_interface() == false then
		local force_X = character:logical_position_x();
		local force_Y = character:logical_position_y();
		
		cm:show_message_event_located(
			character:faction():name(),
			"event_feed_strings_text_wh_dlc07_event_feed_string_scripted_event_blessing_lost_title",
			"event_feed_strings_text_wh_dlc07_event_feed_string_scripted_event_blessing_lost_primary_detail",
			"event_feed_strings_text_wh_dlc07_event_feed_string_scripted_event_blessing_lost_secondary_detail",
			force_X,
			force_Y,
			false,
			711
		);
	end
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("BLESSING_CURRENT_ARMIES", BLESSING_CURRENT_ARMIES, context);
	end
);

cm:add_loading_game_callback(
	function(context)
		BLESSING_CURRENT_ARMIES = cm:load_named_value("BLESSING_CURRENT_ARMIES", {}, context);
	end
);