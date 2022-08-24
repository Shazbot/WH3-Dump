local ui_feature_highlights = {
	-- DLC07 - Bretonnia
	["wh_dlc07_event_feed_scripted_intro_bretonnia"] = {
		{path = {"hud_campaign", "resources_bar", "right spacer_bretonnia", "dy_peasants"}},
		{path = {"hud_campaign", "faction_buttons_docker", "button_spawn_unique_agent"}}
	},
	["wh_dlc07_event_feed_scripted_intro_bordeleaux"] = {
		{path = {"hud_campaign", "resources_bar", "right spacer_bretonnia", "dy_peasants"}},
		{path = {"hud_campaign", "faction_buttons_docker", "button_spawn_unique_agent"}}
	},
	["wh_dlc07_event_feed_scripted_intro_carcassonne"] = {
		{path = {"hud_campaign", "resources_bar", "right spacer_bretonnia", "dy_peasants"}},
		{path = {"hud_campaign", "faction_buttons_docker", "button_spawn_unique_agent"}}
	},
	
	-- DLC08 - Norsca
	["wh_dlc08_event_feed_scripted_intro_norsca"] = {
		{path = {"norsca_gods_frame"}},
		{path = {"button_monsters"}}
	},
	
	-- DLC09 - Tomb Kings
	["wh2_dlc09_event_feed_scripted_intro_tomb_kings"] = {
		{path = {"resources_bar", "right_spacer_tomb_kings", "button_books_of_nagash"}},
		{path = {"faction_buttons_docker", "button_mortuary_cult"}}
	},
	
	-- DLC10 - Queen & Crone
	["wh2_dlc10_event_feed_scripted_intro_hellebron"] = {
		{path = {"hud_campaign", "resources_bar", "topbar_list_parent", "death_night_holder"}},
		{path = {"hud_campaign", "faction_buttons_docker", "button_group_management", "sword_of_khaine", "button_sword_of_khaine"}}
	},
	["wh2_dlc10_event_feed_scripted_intro_alarielle"] = {
		{path = {"hud_campaign", "resources_bar", "topbar_list_parent", "alarielle_holder", "icon_effect"}},
		{path = {"hud_campaign", "faction_buttons_docker", "button_group_management", "sword_of_khaine", "button_sword_of_khaine"}}
	},
	["wh2_dlc10_event_feed_scripted_intro_alith_anar"] = {
		{path = {"hud_campaign", "resources_bar", "topbar_list_parent", "alith_anar_holder"}},
		{path = {"hud_campaign", "faction_buttons_docker", "button_group_management", "sword_of_khaine", "button_sword_of_khaine"}}
	},
	
	-- DLC11 - Vampire Coast
	["wh2_dlc11_event_feed_scripted_intro_harkon"] = {
		{path = {"hud_campaign", "resources_bar", "infamy_holder"}}
	},
	["wh2_dlc11_event_feed_scripted_intro_noctilus"] = {
		{path = {"hud_campaign", "resources_bar", "infamy_holder"}}
	},
	["wh2_dlc11_event_feed_scripted_intro_aranessa"] = {
		{path = {"hud_campaign", "resources_bar", "infamy_holder"}}
	},
	["wh2_dlc11_event_feed_scripted_intro_cylostra"] = {
		{path = {"hud_campaign", "resources_bar", "infamy_holder"}}
	},
	
	-- DLC12 - Prophet & Warlock
	["wh2_dlc12_event_feed_scripted_intro_ikit"] = {
		{path = {"hud_campaign", "faction_buttons_docker", "button_group_management", "button_ikit_workshop"}},
		{path = {"hud_campaign", "resources_bar", "left_spacer_WH2_skin", "ikit_resources"}}
	},
	["wh2_dlc12_event_feed_scripted_intro_tehenhauin"] = {
		{path = {"hud_campaign", "resources_bar", "topbar_list_parent", "sotek_plaque_holder", "plaque_1"}},
		{path = {"hud_campaign", "resources_bar", "topbar_list_parent", "sotek_plaque_holder", "plaque_2"}},
		{path = {"hud_campaign", "resources_bar", "topbar_list_parent", "sotek_plaque_holder", "plaque_3"}},
		{path = {"hud_campaign", "faction_buttons_docker", "button_group_management", "button_sotek_sacrifices"}}
	},

	-- DLC14 - Shadow & Blade
	["wh2_dlc14_event_feed_scripted_intro_snikch"] = {
		{path = {"hud_campaign", "faction_buttons_docker", "button_group_management", "button_shadowy_dealings"}},
		{path = {"hud_campaign", "resources_bar", "topbar_list_parent", "warpstone_dust_holder"}}
	},

	--DLC15 - Warden & Paunch
	["wh2_dlc15_event_feed_scripted_intro_eltharion"] = {
		{path = {"hud_campaign", "faction_buttons_docker", "button_group_management", "button_athel_tamarha_dungeon"}},
		{path = {"hud_campaign", "resources_bar", "topbar_list_parent", "defence_of_yvresse_holder", "defence_level"}}
	},

	--DLC16 - Twisted and Twilight
	["wh2_dlc16_event_feed_scripted_intro_throt"] = {
		--commented this out because it was causing some Scripted Tour confusion
		--{path = {"hud_campaign", "faction_buttons_docker", "button_group_management", "button_flesh_lab"}},
		{path = {"hud_campaign", "resources_bar", "topbar_list_parent", "growth_var_bar_holder", "flesh_lab_top_bar","growth_vat_bar_holder","growth_vat_bar"}}
	},
	["wh2_dlc16_event_feed_scripted_intro_sisters"] = {
		{path = {"hud_campaign", "resources_bar", "topbar_list_parent", "forge_of_daith_holder", "forge_of_daith", "forge_button_holder", "forge_button"}},
		{path = {"hud_campaign", "resources_bar", "topbar_list_parent", "forge_of_daith_holder", "forge_of_daith", "timer", "timer"}}
	},

	--DLC17 - Silence and Fury
	["wh2_dlc17_event_feed_scripted_intro_oxyotl"] = {
		{path = {"hud_campaign", "resources_bar", "topbar_list_parent", "oxyotl_silent_sanctum_holder", "oxyotl_silent_sanctum", "top_bar_holder", "button_holder"}},
		{path = {"hud_campaign", "resources_bar", "topbar_list_parent", "oxyotl_silent_sanctum_holder", "oxyotl_silent_sanctum", "top_bar_holder", "button_holder", "sanctum_button"}},
		{path = {"hud_campaign", "faction_buttons_docker", "button_group_management", "button_threat_map"}}
	}
};

core:add_listener(
	"intro_ui_highlighting_PanelOpenedCampaign",
	"PanelOpenedCampaign",
	function(context)
		return cm:is_new_game() == true and cm:is_multiplayer() == false;
	end,
	function(context)
		local event_type, event_target, event_group = UIComponent(context.component):InterfaceFunction("GetEventType");
		ui_highlighting(event_group, true);
	end,
	true
);
core:add_listener(
	"intro_ui_highlighting_PanelClosedCampaign",
	"PanelClosedCampaign",
	function(context)
		return cm:is_new_game() == true and cm:is_multiplayer() == false;
	end,
	function(context)
		local event_type, event_target, event_group = UIComponent(context.component):InterfaceFunction("GetEventType");
		ui_highlighting(event_group, false);
	end,
	true
);

function ui_highlighting(event_group, highlight)
	local ui_root = core:get_ui_root();
	
	if ui_feature_highlights[event_group] ~= nil then
		for i = 1, #ui_feature_highlights[event_group] do
			local path = ui_feature_highlights[event_group][i].path;
			local ui_component = find_uicomponent(ui_root, unpack(path));
			
			if ui_component then
				if highlight == true then
					if ui_feature_highlights[event_group][i].t == nil then
						local t = ui_component:ShaderTechniqueGet();
						local x, y, z, w = ui_component:ShaderVarsGet();
						ui_feature_highlights[event_group][i].t = t;
						ui_feature_highlights[event_group][i].x = x;
						ui_feature_highlights[event_group][i].y = y;
						ui_feature_highlights[event_group][i].z = z;
						ui_feature_highlights[event_group][i].w = w;
					end
					
					pulse_uicomponent(ui_component, true, 5);
				else
					pulse_uicomponent(ui_component, false);
					
					if ui_feature_highlights[event_group][i].t ~= nil then
						local t = ui_feature_highlights[event_group][i].t;
						local x = ui_feature_highlights[event_group][i].x;
						local y = ui_feature_highlights[event_group][i].y;
						local z = ui_feature_highlights[event_group][i].z;
						local w = ui_feature_highlights[event_group][i].w;
						ui_component:ShaderTechniqueSet(t);
						ui_component:ShaderVarsSet(x, y, z, w);
					end
				end
			end
		end
	end
end