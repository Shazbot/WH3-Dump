



--
-- 	Scripted behaviour for the frontend
--


--	load script libraries
load_script_libraries();





-- load other frontend files
require("frontend_custom_loading_screens");






-- attempt to generate documentation if we haven't already this game session
do	
	if vfs.exists("script/docgen.lua") and not common.is_autotest() then

		local potentially_generate = core:is_tweaker_set("GENERATE_SCRIPT_DOCGEN");
		local always_generate = core:is_tweaker_set("ALWAYS_GENERATE_SCRIPT_DOCGEN");

		local svr = ScriptedValueRegistry:new();

		if always_generate or (potentially_generate and svr:LoadPersistentBool("autodoc_generated") ~= true) then
			require("script.docgen");
			
			if generate_documentation() then
				svr:SavePersistentBool("autodoc_generated", true);
			end;

			package.loaded["script.docgen"] = nil;
		end;
	end;
end




core:add_ui_created_callback(
	function()
		start_new_campaign_listener();
		start_campaign_launch_listener();
		
		-- this flag can be set by autotest scripts
		if not _G.suppress_intro_movie then
			frontend.register_scripted_startup_movie("gam_int");
		end;

		if core:is_tweaker_set("SCRIPTED_TWEAKER_02") then
			local uic_black_fade = core:get_or_create_component("black_fade", "UI/Common UI/black_fade.twui.xml");
			uic_black_fade:SetVisible(true);
			uic_black_fade:SetOpacity(255);
			
			--common.set_custom_loading_screen_key("wh3_main_prologue_initial_load");
			frontend.start_campaign(
				"wh3_main_prologue",
				"wh3_prologue_kislev_expedition",
				"wh3_prologue_political_party_kislev_expedition"
			);
			return;
		end;
		
		-- go to the credits screen immediately if this saved value is set
		if core:svr_load_bool("sbool_frontend_play_credits_immediately") then
			core:svr_save_bool("sbool_frontend_play_credits_immediately", false);
		
			local uic_button_credits = find_uicomponent("button_credits");
			
			if uic_button_credits then
				uic_button_credits:SimulateLClick();
			end;
		end;
		
		if core:is_tweaker_set("UNLOCK_FRONTEND_MOVIES") then
			unlock_campaign_movies();
		end;
	end,
	false
);


--	listen for the singleplayer grand campaign screen being opened and
--	work out if we should check the 'start prelude' checkbox by default
function start_new_campaign_listener()
	core:add_listener(
		"start_new_campaign_listener",
		"FrontendScreenTransition",
		function(context) return context.string == "sp_grand_campaign" end,
		function(context)
			local uic_grand_campaign = find_uicomponent("sp_grand_campaign");
				
			if not uic_grand_campaign then
				script_error("ERROR: start_new_campaign_listener() couldn't find uic_grand_campaign, how can this be?");
				return false;
			end;
				
			if uic_grand_campaign:GetProperty("campaign_key") == "wh2_main_great_vortex" and should_check_start_prelude_by_default() then
				out("Checking prelude checkbox as player has not listened to any startup advice");
				
				uic_grand_campaign:InterfaceFunction("SetupForFirstTime");
			end;
		end,
		true	
	);
end;


--	listen for the 'start campaign' button being clicked and work out if we should
--	start the prelude battle based on the value of the 'start prelude' checkbox
function start_campaign_launch_listener()
	core:add_listener(
		"start_campaign_button_listener",
		"ComponentLClickUp",
		function(context) return context.string == "button_start_campaign" and uicomponent_descended_from(UIComponent(context.component), "campaign_select_new") end,
		function(context)			
			-- work out if we have to load the full intro
			local uic_prelude = find_uicomponent("checkbox_start_prelude");
			intro_enabled = (uic_prelude and uic_prelude:CurrentState() == "selected") or core:is_tweaker_set("FORCE_FULL_CAMPAIGN_PRELUDE");
			
			-- try and set a custom loading screen
			set_custom_loading_screen(intro_enabled);
			
			if intro_enabled then
				-- this value will be read by the campaign script to decide what to do
				core:svr_save_bool("sbool_load_intro_campaign", true);
			end;
		end,
		true
	);
	
	core:add_listener(
		"mpc_loading_screen_listener",
		"ComponentLClickUp",
		function(context)
			return find_uicomponent("mp_grand_campaign") and context.string == "button_ready" and not common.get_context_value("FrontendRoot.CampaignLobbyContext.IsResumed");
		end,
		function()
			local loading_screen = custom_loading_screens_no_intro[common.get_context_value("FrontendRoot.CampaignLobbyContext.LocalPlayerSlotContext.CurrentLordContext.GeneralKey")];
			
			if common.get_context_value("IsContextValid(FrontendRoot.CampaignLobbyContext.CampaignStartInfoContext.TimeOfLegendsCampaignRecordContext)") then
				loading_screen = loading_screen .. "_tol";
			end;
			
			common.set_custom_loading_screen_key(loading_screen);
		end,
		true
	);
end;







function set_custom_loading_screen(intro_enabled)
	local ui_root = core:get_ui_root();

	-- work out which campaign/lord is selected
	for i = 0, ui_root:ChildCount() - 1 do
		local uic_root_child = UIComponent(ui_root:Find(i));
		
		if uic_root_child:Visible() then
			-- this child of root is visible (it may be a campaign), see if we can find lord select list
			local uic_lord_select_list = find_uicomponent(uic_root_child, "lord_select_list", "list_box");
			
			if uic_lord_select_list then
				-- we have a campaign screen with a visible lord_select_list
				-- go through the lords in the list, and work out which one is selected
				for j = 0, uic_lord_select_list:ChildCount() - 1 do
					local uic_child = UIComponent(UIComponent(uic_lord_select_list:Find(j)):Find("lord_button"));
					
					if uic_child:CurrentState() == "selected" then
						local start_pos_id = uic_child:GetProperty("lord_key");
						
						-- the player is starting a campaign with this faction, see if we have a custom loading screen for it
						if intro_enabled then
							local loading_screen = custom_loading_screens_with_intro[start_pos_id];
							if loading_screen then
								out("set_custom_loading_screen() is overriding loading screen with text key [" .. loading_screen .. "], first-turn intro is enabled");
								common.set_custom_loading_screen_key(loading_screen);
							else
								script_error("ERROR: set_custom_loading_screen() called, but couldn't find a loading screen override for character with start pos id " .. start_pos_id .. " (first-turn intro is enabled)");
							end;
						else
							local loading_screen = custom_loading_screens_no_intro[start_pos_id];
							if loading_screen then
								out("set_custom_loading_screen() is overriding loading screen with text key [" .. loading_screen .. "], starting normal campaign without first-turn intro");
								common.set_custom_loading_screen_key(loading_screen);
							else
								script_error("ERROR: set_custom_loading_screen() called, but couldn't find a loading screen override for character with start pos id " .. start_pos_id .. " (normal campaign without first-turn intro)");
							end;
						end;
						
						return;
					end;
				end;
				
				script_error("ERROR: set_custom_loading_screen() called but couldn't find a selected lord");
				return;
			end;
		end;
	end;
	
	script_error("ERROR: set_custom_loading_screen() called but couldn't find a visible campaign screen");
end;











--	for each intro advice thread key, check its score - if it's above 0 then it's been played
--	before, so we shouldn't check the start prelude checkbox
function should_check_start_prelude_by_default()
	if _G.is_autotest then
		out("This is an autorun so not checking prelude checkbox");
		return false;
	end;
	
	if core:is_tweaker_set("PRELUDE_BATTLE_DISABLED_BY_DEFAULT") then
		out("Tweaker PRELUDE_BATTLE_DISABLED_BY_DEFAULT is set so not checking prelude checkbox");
		return false;
	end;

	if common.get_advice_history_string_seen("player_has_stated_campaign") or common.get_advice_history_string_seen("player_has_started_campaign") then
		return false;
	end;
	
	return true;
end;




function unlock_campaign_movies()
	local movies_to_unlock = {
		"belakor_1",
		"belakor_2",
		"belakor_3",
		"belakor_4",
		"cth_win",
		"dae_win",
		"journey_to_forge",
		"kho_win_ska",
		"ksl_intro_bor",
		"ksl_win_bor",
		"ksl_win_kat",
		"ksl_win_kot",
		"nur_win_plg",
		"ogr_win_gre",
		"ogr_win_skg",
		"pro_win",
		"sla_win_nka",
		"tze_win_fat",
		"chs_win",
		"dlc20_azazel_win",
		"dlc20_festus_win",
		"dlc20_valkia_win",
		"dlc20_vilitch_win",
		"wh3_dlc23_chd_ancestor_hellshard_structure",
		"wh3_dlc23_story_panel_intro_chd",
		"wh3_dlc23_story_panel_narrative_petrification_01",
		"wh3_dlc23_story_panel_narrative_petrification_02",
		"wh3_dlc23_story_panel_narrative_petrification_03",
		"wh3_dlc23_story_panel_narrative_petrification_04",
		"wh3_dlc23_story_panel_narrative_relic_01",
		"wh3_dlc23_story_panel_narrative_relic_02",
		"wh3_dlc23_story_panel_narrative_relic_03",
		"wh3_dlc23_story_panel_narrative_relic_04",
		"wh3_dlc23_story_panel_narrative_sacrifice_chd",
		"dlc23_astragoth_win",
		"dlc23_drazhoath_win",
		"dlc23_zhatan_win"
	};
	
	for i = 1, #movies_to_unlock do
		core:svr_save_registry_bool(movies_to_unlock[i], true);
	end;
end;