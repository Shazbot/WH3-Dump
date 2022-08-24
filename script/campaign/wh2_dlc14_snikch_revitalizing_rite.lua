local snikch_faction = "wh2_main_skv_clan_eshin";

function add_snikch_revitalizing_listeners()
	out("#### Adding Sniktch Revitalizing Lister ####");
	core:add_listener(
		"snikch_RitualCompletedEvent",
		"RitualCompletedEvent",
		function(context)
			local ritual = context:ritual():ritual_key();
			
			if ritual == "wh2_dlc14_rituals_skv_revitalizing" then
				return context:performing_faction():name() == snikch_faction;
			end
		end,
		function(context)			
			local snikch_interface = context:performing_faction();
			local snikch_cqi = snikch_interface:command_queue_index();
			local snikch_char_list = snikch_interface:character_list();
			local snikch_force_list = snikch_interface:military_force_list();

			for i = 0, snikch_char_list:num_items() - 1 do
				local snikch_char = snikch_char_list:item_at(i);

				-- return convalescing characters back into action
				cm:stop_character_convalescing(snikch_char:cqi());
			end
			for j = 0, snikch_force_list:num_items() - 1 do
				local snikch_force = snikch_force_list:item_at(j);
				local unit_list = snikch_force:unit_list();

				for h = 0, unit_list:num_items() - 1 do
					local unit = unit_list:item_at(h);
					-- returns forces to max health
					cm:set_unit_hp_to_unary_of_maximum(unit, 1);
				end
			end
		end,
		true 
	);
end	
	
	
			
		