local yvresse_region_key = "wh3_main_combi_region_tor_yvresse"

function add_eltharion_yvresse_defence_listeners()
    out("#### Adding Eltharion Tor Yvresse Siege Defence Level Listeners ####");

    -- apply effects based on current Tor Yvresse defence level
    core:add_listener(
        "yvresse_defence_level_monitor",
        "PendingBattle",
        function()
            local pb = cm:model():pending_battle();

            return pb:siege_battle() and pb:has_defender() and pb:defender():region():name() == yvresse_region_key;
        end,
        function()
            local pb = cm:model():pending_battle();
            local defender = pb:defender();
			local faction = defender:faction();
			local region = defender:region():name();
			
            if faction:name() == "wh2_main_hef_yvresse" then
				local yvresse_defence = faction:pooled_resource_manager():resource("yvresse_defence"):value();
				
				if yvresse_defence <= 24 then
					cm:pending_battle_add_scripted_tile_upgrade_tag("settlement_level_1")
					out("Tor Yvresse defence level 1 map being loaded!")
				elseif yvresse_defence >= 25 and yvresse_defence <= 49 then
					cm:pending_battle_add_scripted_tile_upgrade_tag("settlement_level_1")
					cm:apply_effect_bundle_to_region("wh2_dlc15_hef_army_abilities_defence_level_1", region, 0)
					out("Tor Yvresse defence level 1 map being loaded!")
				elseif yvresse_defence >= 50 and yvresse_defence <= 74 then
					cm:pending_battle_add_scripted_tile_upgrade_tag("settlement_level_2")
					cm:apply_effect_bundle_to_region("wh2_dlc15_hef_army_abilities_defence_level_2", region, 0)
					out("Tor Yvresse defence level 2 map being loaded!")
				elseif yvresse_defence >= 75 then
					cm:pending_battle_add_scripted_tile_upgrade_tag("settlement_level_3")
					cm:apply_effect_bundle_to_region("wh2_dlc15_hef_army_abilities_defence_level_3", region, 0)
					out("Tor Yvresse defence level 3 map being loaded!")
				end
				
				cm:update_pending_battle();
            else
                cm:pending_battle_add_scripted_tile_upgrade_tag("settlement_level_3") -- to ensure a settlement level is still used on this siege map with any other faction
            end
        end,
        true
	);
	
	-- add scene surrounding Tor Yvresse based on current defence level
    core:add_listener(
        "yvresse_scenery_monitor",
        "WorldStartRound",
		true,
		function()
			local eltharion_faction = cm:get_faction("wh2_main_hef_yvresse");
			
			if eltharion_faction:is_dead() then
				-- return to ruins if Eltharion is dead
				cm:remove_scripted_composite_scene("yvresse_scenery");
			else
				local yvresse_defence = eltharion_faction:pooled_resource_manager():resource("yvresse_defence"):value();
				
				local current_yvresse_cs_level = cm:get_saved_value("current_yvresse_cs_level");
				local should_change = false;
				
				if yvresse_defence <= 49 and current_yvresse_cs_level ~= 1 then
					should_change = true;
					current_yvresse_cs_level = 1;
				elseif yvresse_defence >= 50 and yvresse_defence <= 74 and current_yvresse_cs_level ~= 2 then
					should_change = true;
					current_yvresse_cs_level = 2;
				elseif yvresse_defence >= 75 and current_yvresse_cs_level ~= 3 then
					should_change = true;
					current_yvresse_cs_level = 3;
				end;
				
				if should_change then
					cm:set_saved_value("current_yvresse_cs_level", current_yvresse_cs_level);
					
					if cm:turn_number() > 1 then
						cm:remove_scripted_composite_scene("yvresse_scenery");
					end;
					
					local cs_name = "hef_tor_yvresse_me_0" .. current_yvresse_cs_level;
					
					out("* update_tor_yvresse_scenery is updating scenery of " .. yvresse_region_key .. " with composite scene " .. cs_name);
					cm:add_scripted_composite_scene_to_settlement("yvresse_scenery", cs_name, cm:get_region(yvresse_region_key), 0, 0, false, true, false);
				end;
			end
		end,
		true
	);
end