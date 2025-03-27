kislev_devotion = {
	devotion_amount_per_force_ritual = 50,
	devotion_amount_per_province_ritual = 50
} 

function kislev_devotion:setup_kislev_devotion()
	common.set_context_value("kislev_devotion_amount_per_ritual", self.devotion_amount_per_force_ritual);

	-- set public order after ritual is performed
	core:add_listener(
		"kislev_ritual_performed",
		"RitualCompletedEvent",
		true,
		function(context)
			local ritual = context:ritual();

			if ritual:ritual_category() == "MOTHERLAND_RITUAL_FORCE" then
				local force = ritual:ritual_target():get_target_force();

				if force:has_general() == true then
					local general = force:general_character();

					if general:has_region() == true then
						local region = general:region();
						local public_order = region:public_order();
						local new_value = public_order + (0 - self.devotion_amount_per_force_ritual);
						
						cm:set_public_order_of_province_for_region(region:name(), new_value);
					end
				end
			elseif ritual:ritual_category() == "MOTHERLAND_RITUAL_PROVINCE" then
				local region = context:ritual():ritual_target():get_target_region();
				local public_order = region:public_order();
				local new_value = public_order + (0 - self.devotion_amount_per_province_ritual);
				
				cm:set_public_order_of_province_for_region(region:name(), new_value);

				if ritual:ritual_key() == "wh3_main_ritual_ksl_winter_salyak_province" then
					cm:heal_garrison(region:cqi());
				end
			end
		end,
		true
	);
end