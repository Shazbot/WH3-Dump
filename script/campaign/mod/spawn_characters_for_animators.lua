

------------------------------------------------------------------------------
--
--	Spawn Characters for Animators mod
--	Mark S
--
--	Spawns a number of characters on the campaign map for animators to
--	test their work if the tweaker SCRIPTED_TWEAKER_15 is set.
------------------------------------------------------------------------------


function spawn_characters_for_animators()
	local tweaker_name = "SCRIPTED_TWEAKER_15";

	if core:is_tweaker_set(tweaker_name) then

		script_error("INFO: spawn_characters_for_animators() is spawning characters. This is not a bug, it just means the spawn_characters_for_animators() mod is present and tweaker value [" .. tweaker_name .. "] is set");

		local characters_to_create = {
			["wh3_main_cth_alchemist"] = "engineer",
			["wh3_main_cth_astromancer"] = "wizard",
			["wh3_main_cth_dragon_blooded_shugengan_yang"] = "general",
			["wh3_main_cth_lord_magistrate_yang"] = "general",
			["wh3_main_cth_miao_ying"] = "general",
			["wh3_main_cth_zhao_ming"] = "general",
			["wh3_main_dae_belakor"] = "general",
			["wh3_main_dae_daemon_prince"] = "general",
			["wh3_main_kho_bloodreaper"] = "dignitary",
			["wh3_main_kho_cultist"] = "runesmith",
			["wh3_main_kho_exalted_bloodthirster"] = "general",
			["wh3_main_kho_herald_of_khorne"] = "general",
			["wh3_main_kho_skarbrand"] = "general",
			["wh3_main_ksl_boris"] = "general",
			["wh3_main_ksl_boyar"] = "general",
			["wh3_main_ksl_frost_maiden_ice"] = "wizard",
			["wh3_main_ksl_ice_witch_ice"] = "general",
			["wh3_main_ksl_katarin"] = "general",
			["wh3_main_ksl_kostaltyn"] = "general",
			["wh3_main_ksl_patriarch"] = "dignitary",
			["wh3_main_nur_cultist"] = "dignitary",
			["wh3_main_nur_exalted_great_unclean_one_death"] = "general",
			["wh3_main_nur_herald_of_nurgle_death"] = "general",
			["wh3_main_nur_kugath"] = "general",
			["wh3_main_nur_plagueridden_death"] = "spy",
			["wh3_main_ogr_butcher_beasts"] = "wizard",
			["wh3_main_ogr_firebelly"] = "dignitary",
			["wh3_main_ogr_greasus_goldtooth"] = "general",
			["wh3_main_ogr_hunter"] = "spy",
			["wh3_main_ogr_skrag_the_slaughterer"] = "general",
			["wh3_main_ogr_slaughtermaster_beasts"] = "general",
			["wh3_main_ogr_tyrant"] = "general",
			["wh3_main_sla_alluress_shadow"] = "engineer",
			["wh3_main_sla_cultist"] = "dignitary",
			["wh3_main_sla_exalted_keeper_of_secrets_shadow"] = "general",
			["wh3_main_sla_herald_of_slaanesh_shadow"] = "general",
			["wh3_main_sla_nkari"] = "general",
			["wh3_main_tze_cultist"] = "dignitary",
			["wh3_main_tze_exalted_lord_of_change_metal"] = "general",
			["wh3_main_tze_herald_of_tzeentch_metal"] = "general",
			["wh3_main_tze_iridescent_horror_metal"] = "runesmith",
			["wh3_main_tze_kairos"] = "general"
		};
		
		local start_x = 404;
		local start_y = 133;
		local cultures_created = {};
		
		local faction_list = cm:model():world():faction_list();
		local row = 0;
		
		for i = 0, faction_list:num_items() - 1 do
			local current_faction = faction_list:item_at(i);
			
			if current_faction:can_be_human() then
				local culture = current_faction:culture();
				local culture_already_created = false;
				
				for j = 1, #cultures_created do
					if culture == cultures_created[j] then
						culture_already_created = true;
						break;
					end;
				end;
				
				if not culture_already_created then
					table.insert(cultures_created, culture);
					row = row + 4;
					
					local column = 0;
					
					for k, v in pairs(characters_to_create) do
						if string.sub(k, 1, 12) == string.sub(culture, 1, 12) then
							column = column + 4;
							local x = start_x + column;
							local y = start_y + row;
							
							if v == "general" then
								cm:create_force_with_general(
									current_faction:name(),
									"wh3_main_kho_inf_bloodletters_0",
									"wh3_main_chaos_region_kislev",
									x,
									y,
									v,
									k,
									"",
									"",
									"",
									"",
									true
								);
							else
								cm:create_agent(current_faction:name(), v, k, x, y);
							end;
						end;
					end;
				end;
			end;
		end;
	end;
end;
