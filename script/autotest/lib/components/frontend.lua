function Lib.Components.Frontend.campaign_tab()
    return Functions.find_component("buttons_holder:buttons_list:campaign:button_campaign")
end

function Lib.Components.Frontend.new_campaign()
    return Functions.find_component("fe_campaign_new_campaign")
end

function Lib.Components.Frontend.load_campaign()
    return Functions.find_component("campaign_buttons:load_campaign:button_load_campaign")
end

function Lib.Components.Frontend.multiplayer_campaign()
    return Functions.find_component("fe_campaign_multiplayer_campaign")
end

function Lib.Components.Frontend.multiplayer_quick_battle()
    return Functions.find_component("fe_battles_quick_multiplayer_battle")
end

function Lib.Components.Frontend.multiplayer_ranked_battle()
    return Functions.find_component("fe_battles_ranked_multiplayer_battle")
end

function Lib.Components.Frontend.quest_battle()
    return Functions.find_component("fe_battles_quest_battles")
end

function Lib.Components.Frontend.replays()
    return Functions.find_component("battle_buttons:replays:button_replays")
end

function Lib.Components.Frontend.replays_parent()
    return Functions.find_component("sp_replays:main_panel:list_panel:listview:list_clip:list_box")
end

function Lib.Components.Frontend.replay(replay_id)
    local path = Functions.find_path_from_component(Lib.Components.Frontend.replays_parent())
    return Functions.find_component(path..":"..replay_id)
end

function Lib.Components.Frontend.replay_name(replay_id)
    local path = Functions.find_path_from_component(Lib.Components.Frontend.replays_parent())
    return Functions.find_component(path..":"..replay_id..":name")
end

function Lib.Components.Frontend.watch_replay()
    return Functions.find_component("sp_replays:main_panel:button_holder:button_watch")
end

function Lib.Components.Frontend.fight_replay()
    return Functions.find_component("sp_replays:main_panel:button_holder:button_fight")
end

function Lib.Components.Frontend.new_campaign_panel()
    return Functions.find_component("fe_new_campaign_panel")
end

function Lib.Components.Frontend.prologue_campaign_parent()
    return Functions.find_component("campaign_holder:campaign_button_holder:prologue_campaign_holder")
end

function Lib.Components.Frontend.prologue_campaign()
    return Functions.find_component("campaign_button_holder:prologue_campaign_holder:button_prologue")
end

function Lib.Components.Frontend.vortex_campaign()
    return Functions.find_component("campaign_select:list_parent:CcoCampaignMapPlayableAreaRecord328425926")
end

function Lib.Components.Frontend.chaos_campaign()
    return Functions.find_component("campaign_holder:campaign_button_holder:list_parent:CcoCampaignMapPlayableAreaRecord856762626")
end

function Lib.Components.Frontend.combined_map_campaign()
    return Functions.find_component("campaign_select:list_parent:CcoCampaignMapPlayableAreaRecord328425926")
end

function Lib.Components.Frontend.immortal_empires_campaign()
    return Functions.find_component("campaign_holder:campaign_button_holder:list_parent:CcoCampaignMapPlayableAreaRecord119056105")
end

--not used, check UI path if using it
function Lib.Components.Frontend.campaign_select_name()
    return Functions.find_component("campaign_select:list_parent:CcoCampaignMapPlayableAreaRecord328425926:label_name")
end

function Lib.Components.Frontend.campaign_name()
    return Functions.find_component("campaign_select_holder:button_select_campaign:selected_campaign_text")
end

function Lib.Components.Frontend.campaign_select_continue()
    return Functions.find_component("side_panel_holder:button_list:lord_select_holder:button_select_lord")
end

function Lib.Components.Frontend.start_campaign()
    return Functions.find_component("fe_new_campaign_start_campaign")
end

function Lib.Components.Frontend.go_to_store_button()
    return Functions.find_component("button_purchase")
end

function Lib.Components.Frontend.campaign_race_parent()
    return Functions.find_component("faction_holder:button_select_race:popup_menu:content:culture_list")
end

function Lib.Components.Frontend.campaign_race_select(race)
    local path = Functions.find_path_from_component(Lib.Components.Frontend.campaign_race_parent())
    return Functions.find_component(path..":"..race..":race_button")
end

function Lib.Components.Frontend.campaign_race_select_name(race_id)
    local path = Functions.find_path_from_component(Lib.Components.Frontend.campaign_race_parent())
    return Functions.find_component(path..":"..race_id..":dy_race")
end

function Lib.Components.Frontend.lord_select_panel()
    return Functions.find_component("fe_lord_select_panel")
end

function Lib.Components.Frontend.campaign_lord_parent()
    return Functions.find_component("fe_new_campaign_lord_select_parent")
end

function Lib.Components.Frontend.campaign_lord_select(lord)
	return Functions.find_component(lord..":lord_button")
end

 function Lib.Components.Frontend.campaign_lord_select_name()
 	return Functions.find_component("lord_details_panel:name_and_icon_holder:name_clip:name_holder:dy_faction_leader")
end

function Lib.Components.Frontend.battles_tab()
    return Functions.find_component("buttons_holder:buttons_list:battle:button_battle")
end

function Lib.Components.Frontend.custom_battle()
    return Functions.find_component("fe_battles_custom_battle")
end

function Lib.Components.Frontend.add_player(team)
    if(team == 1) then
        team = "top"
    else
        team = "bottom"
    end
    return Functions.find_component("custom_battle:ready_parent:teams_parent:"..team.."_team_parent:"..team.."_team:slot_parent:add_list:button_add_ai")
end

function Lib.Components.Frontend.player_slot_options(team, player)
    if(team == 1) then
        team = "top"
    else
        team = "bottom"
    end

    local player_slot_parent = Functions.find_component("custom_battle:ready_parent:teams_parent:"..team.."_team_parent:"..team.."_team:slot_parent:player_slot_list")
    local player_component_id = UIComponent(player_slot_parent:Find(player)):Id()

    return Functions.find_component("custom_battle:ready_parent:teams_parent:"..team.."_team_parent:"..team.."_team:slot_parent:player_slot_list:"..player_component_id..":button_toggle_options")
end

function Lib.Components.Frontend.remove_player(team, player)
    if(team == 1) then
        team = "top"
    else
        team = "bottom"
    end
    local player_slot_parent = Functions.find_component("custom_battle:ready_parent:teams_parent:"..team.."_team_parent:"..team.."_team:slot_parent:player_slot_list")
    local player_comp = UIComponent(player_slot_parent:Find(player))
    local button_list = UIComponent(player_comp:Find("button_list"))
    return UIComponent(button_list:Find("button_remove"))
end

--the player list number changed, previously player 1 of team 2 would have an ID ending in 0 just like player 1 of team 2, however that is no longer the case
--instead their ID ends in a number related to the order they were added so if two players were added to team 1 and then one player to team 2 the team 2 players ID would end in 2 (0, 1, 2) as the third player added
--to get around this, we get the slot list parent and then find the child corresponding to the player number supplied
--children indexs start at 0 but there is a template in the 0th slot so the children we want actually start at 1
function Lib.Components.Frontend.custom_battle_select_player(team, player)
    if(team == 1) then
        team = "top"
    else
        team = "bottom"
    end
    local player_slot_parent = Functions.find_component("custom_battle:ready_parent:teams_parent:"..team.."_team_parent:"..team.."_team:slot_parent:player_slot_list")
    return UIComponent(player_slot_parent:Find(player))
end

function Lib.Components.Frontend.custom_battle_change_faction()
    return Functions.find_component("fe_custom_battle_select_race")
end

function Lib.Components.Frontend.custom_battle_faction_parent()
	return Functions.find_component("fe_custom_battle_faction_list_parent")
end

function Lib.Components.Frontend.custom_battle_unit_parent()
    return Functions.find_component("fe_custom_battle_recruited_unit_list_parent")
end

function Lib.Components.Frontend.custom_battle_autogenerate()
    return Functions.find_component("fe_custom_battle_autogenerate_army")
end

function Lib.Components.Frontend.custom_battle_autogenerate_reinforcing_army()
    return Functions.find_component("fe_custom_battle_autogenerate_reinforcement_army")
end

function Lib.Components.Frontend.custom_battle_battle_type_parent()
    return Functions.find_component("fe_custom_battle_battle_type_parent")
end

function Lib.Components.Frontend.custom_battle_battle_type(type_id)
    local path = Functions.find_path_from_component(Lib.Components.Frontend.custom_battle_battle_type_parent())
    return Functions.find_component(path..":"..type_id)
end

function Lib.Components.Frontend.custom_battle_battle_type_name(type_id)
    local path = Functions.find_path_from_component(Lib.Components.Frontend.custom_battle_battle_type_parent())
    return Functions.find_component(path..":"..type_id..":button_txt_small")
end

function Lib.Components.Frontend.custom_battle_map_parent()
    return Functions.find_component("fe_cutom_battle_map_list_parent")
end

function Lib.Components.Frontend.custom_battle_map(map_id)
    local path = Functions.find_path_from_component(Lib.Components.Frontend.custom_battle_map_parent())
    return Functions.find_component(path..":"..map_id)
end

function Lib.Components.Frontend.custom_battle_map_name(map_id)
    local path = Functions.find_path_from_component(Lib.Components.Frontend.custom_battle_map_parent())
    return Functions.find_component(path..":"..map_id..":label_context_name")
end

function Lib.Components.Frontend.battle_difficulty()
    return Functions.find_component("dropdown_difficulty")
end

function Lib.Components.Frontend.battle_time_limit()
    return Functions.find_component("dropdown_time_limit")
end

function Lib.Components.Frontend.battle_funds()
    return Functions.find_component("dropdown_funds_type")
end

function Lib.Components.Frontend.tower_level()
    return Functions.find_component("dropdown_settlement_level")
end

function Lib.Components.Frontend.unit_scale()
    return Functions.find_component("dropdown_unit_scale")
end

function Lib.Components.Frontend.battle_realism()
    return Functions.find_component("fe_custom_battle_realism_checkbox")
end

function Lib.Components.Frontend.battle_large_armies()
    return Functions.find_component("fe_custom_battle_large_armies_checkbox")
end

function Lib.Components.Frontend.battle_unit_caps()
    return Functions.find_component("fe_custom_battle_unit_caps_checkbox")
end

function Lib.Components.Frontend.army_setup_tab()
    return Functions.find_component("fe_custom_battle_army_setup_tab")
end

function Lib.Components.Frontend.map_setup_tab()
    return Functions.find_component("fe_custom_battle_map_setup_tab")
end

function Lib.Components.Frontend.custom_battle_start()
    return Functions.find_component("fe_custom_battle_start_battle")
end

function Lib.Components.Frontend.options_tab()
    return Functions.find_component("left_holder:buttons_holder:buttons_list:options:button_options")
end

function Lib.Components.Frontend.options_graphics()
    return Functions.find_component("options_frame:options_buttons:graphics:button_graphics")
end

function Lib.Components.Frontend.options_sound()
    return Functions.find_component("options_frame:options_buttons:sound:button_sound")
end

function Lib.Components.Frontend.options_controls()
    return Functions.find_component("options_frame:options_buttons:controls:button_controls")
end

function Lib.Components.Frontend.options_game_settings()
    return Functions.find_component("options_frame:options_buttons:game_settings:button_game_settings")
end

function Lib.Components.Frontend.options_credits()
    return Functions.find_component("buttons_holder:buttons_list:buttons_holder:button_credits")
end

function Lib.Components.Frontend.side_tab_options_graphics()
    return Functions.find_component("fe_options_graphics_small")
end

function Lib.Components.Frontend.side_tab_options_sound()
    return Functions.find_component("fe_options_audio_small")
end

function Lib.Components.Frontend.side_tab_options_controls()
    return Functions.find_component("fe_options_controls_small")
end

function Lib.Components.Frontend.side_tab_options_game_settings()
    return Functions.find_component("fe_options_ui_small")
end

function Lib.Components.Frontend.side_tab_options_credits()
    return Functions.find_component("fe_options_credits_small")
end

function Lib.Components.Frontend.resolution_dropdown()
    return Functions.find_component("basic_options:dropdown_resolution")
end

function Lib.Components.Frontend.graphics_quality_dropdown()
    return Functions.find_component("basic_options:dropdown_quality")
end

function Lib.Components.Frontend.apply_graphics()
    return Functions.find_component("fe_graphics_apply_changes")
end

function Lib.Components.Frontend.recommended_graphics()
    return Functions.find_component("button_recommended")
end

function Lib.Components.Frontend.graphics_advanced()
    return Functions.find_component("fe_graphics_advanced_tab")
end

function Lib.Components.Frontend.graphics_benchmark_button()
    return Functions.find_component("fe_graphics_benchmark")
end

function Lib.Components.Frontend.benchmark_list_parent()
    return Functions.find_component("fe_benchmarks_list_parent")
end

function Lib.Components.Frontend.select_benchmark(benchmark)
    local path = Functions.find_path_from_component(Lib.Components.Frontend.benchmark_list_parent())
    return Functions.find_component(path..":"..benchmark)
end

function Lib.Components.Frontend.benchmark_name(benchmark)
    local path = Functions.find_path_from_component(Lib.Components.Frontend.benchmark_list_parent())
    return Functions.find_component(path..":"..benchmark..":name")
end

function Lib.Components.Frontend.start_benchmark()
    return Functions.find_component("fe_benchmark_ok_button")
end

function Lib.Components.Frontend.cancel_benchmark()
    return Functions.find_component("fe_benchmarks_cancel_button")
end

function Lib.Components.Frontend.quit_confirmation()
    return Functions.find_component("db_both_tick")
end

function Lib.Components.Frontend.return_to_main_menu()
    return Functions.find_component("fe_return_to_main")
end

function Lib.Components.Frontend.dlc_popup_button_close()
    return Functions.find_component("popup_new_content:button_group:button_holder:button_close")
end

function Lib.Components.Frontend.close_popup()
    return Functions.find_component("popup_message_box:ok_group:button_tick")
end

function Lib.Components.Frontend.quit_to_windows()
    return Functions.find_component("fe_quit_to_windows")
end

function Lib.Components.Frontend.graphics_texture_quality_dropdown()
    return Functions.find_component("dropdown_texture_quality")
end

function Lib.Components.Frontend.graphics_shadow_detail_dropdown()
    return Functions.find_component("dropdown_shadows")
end

function Lib.Components.Frontend.graphics_vfx_detail_dropdown()
    return Functions.find_component("dropdown_particle_effects")
end

function Lib.Components.Frontend.graphics_tree_detail_dropdown()
    return Functions.find_component("dropdown_trees")
end

function Lib.Components.Frontend.graphics_unit_detail_dropdown()
    return Functions.find_component("dropdown_unit_detail")
end

function Lib.Components.Frontend.graphics_dof_dropdown()
    return Functions.find_component("dropdown_dop")
end

function Lib.Components.Frontend.graphics_reflections_dropdown()
    return Functions.find_component("dropdown_reflections")
end

function Lib.Components.Frontend.graphics_fog_dropdown()
    return Functions.find_component("dropdown_fog")
end

function Lib.Components.Frontend.graphics_anti_aliasing_dropdown()
    return Functions.find_component("dropdown_aliasing")
end

function Lib.Components.Frontend.graphics_texture_filtering_dropdown()
    return Functions.find_component("dropdown_filtering")
end

function Lib.Components.Frontend.graphics_grass_detail_dropdown()
    return Functions.find_component("dropdown_grass")
end

function Lib.Components.Frontend.graphics_terrain_detail_dropdown()
    return Functions.find_component("dropdown_terrain")
end

function Lib.Components.Frontend.graphics_building_detail_dropdown()
    return Functions.find_component("dropdown_building_detail")
end

function Lib.Components.Frontend.graphics_unit_size_dropdown()
    return Functions.find_component("dropdown_unit_size")
end

function Lib.Components.Frontend.graphics_porthole_quality_dropdown()
    return Functions.find_component("dropdown_porthole")
end

function Lib.Components.Frontend.graphics_corpse_lifespan_dropdown()
    return Functions.find_component("dropdown_hide_bodies")
end

function Lib.Components.Frontend.graphics_unlimited_memory_checkbox()
    return Functions.find_component("fe_graphics_unlimited_memory_checkbox")
end

function Lib.Components.Frontend.graphics_vsync_checkbox()
    return Functions.find_component("fe_graphics_v_sync_checkbox")
end

function Lib.Components.Frontend.graphics_vignette_checkbox()
    return Functions.find_component("fe_graphics_vignette_checkbox")
end

function Lib.Components.Frontend.graphics_proximity_fade_checkbox()
    return Functions.find_component("fe_graphics_proximity_fade_checkbox")
end

function Lib.Components.Frontend.graphics_ssao_checkbox()
    return Functions.find_component("fe_graphics_ssao_checkbox")
end

function Lib.Components.Frontend.graphics_sharpening_checkbox()
    return Functions.find_component("fe_graphics_sharpening_checkbox")
end

function Lib.Components.Frontend.graphics_sss_checkbox()
    return Functions.find_component("checkbox_sss")
end

function Lib.Components.Frontend.graphics_lighting_quality_dropdown()
    return Functions.find_component("dropdown_lighting_quality")
end

function Lib.Components.Frontend.graphics_apply_ui_scale()
    return Functions.find_component("button_apply_ui_scale")
end

function Lib.Components.Frontend.graphics_increase_ui_scale()
    return Functions.find_component("graphics_parent:panel_advanced:scale_parent:ui_scale:hslider:right")
end

function Lib.Components.Frontend.graphics_decrease_ui_scale()
    return Functions.find_component("graphics_parent:panel_advanced:scale_parent:ui_scale:hslider:left")
end

function Lib.Components.Frontend.graphics_windowed_checkbox()
    return Functions.find_component("checkbox_windowed")
end

function Lib.Components.Frontend.quest_battle_menu()
	return Functions.find_component("quest_battles")
end

function Lib.Components.Frontend.quest_battle_faction_header()
	return Functions.find_component("quest_battles:main:faction_holder:selected_race_parent:label_race_name")
end

function Lib.Components.Frontend.quest_battle_select_parent()
    return Functions.find_component("fe_quest_battle_battle_select_parent")
end

function Lib.Components.Frontend.quest_battle_list()
	return Functions.find_component("quest_battles:main:selected_character_parent:battle_listview:list_clip:battle_list")
end

function Lib.Components.Frontend.quest_battle_localised_name(battle_ui_component)
	local path = Functions.find_path_from_component(battle_ui_component)
	return Functions.find_component(path..":label_battle_name")
end

function Lib.Components.Frontend.quest_battle_select(battle)
    local path = Functions.find_path_from_component(Lib.Components.Frontend.quest_battle_select_parent())
    return Functions.find_component(path..":"..battle)
end

function Lib.Components.Frontend.quest_battle_difficulty()
    return Functions.find_component("dropdown_battle_difficulty")
end

function Lib.Components.Frontend.quest_battle_faction_parent()
	return Functions.find_component("quest_battles:main:faction_holder:button_select_race")
end

function Lib.Components.Frontend.quest_battle_faction_list_box()
	return Functions.find_component("quest_battles:main:faction_holder:button_select_race:popup_menu:list_box")
end

function Lib.Components.Frontend.quest_battle_lord_parent()
    return Functions.find_component("quest_battles:main:faction_holder:selected_race_parent:lord_list")
end

function Lib.Components.Frontend.quest_battle_lord_select(lord)
    local path = Functions.find_path_from_component(Lib.Components.Frontend.quest_battle_lord_parent())
    return Functions.find_component(path..":"..lord..":lord_button")
end

function Lib.Components.Frontend.quest_battle_lord_name()
	return Functions.find_component("quest_battles:main:selected_character_parent:label_character_name")
end

function Lib.Components.Frontend.quest_battle_start()
	return Functions.find_component("quest_battles:main:start_button_frame:button_start_battle")
end

function Lib.Components.Frontend.load_game_panel()
    return Functions.find_component("fe_load_save_panel")
end

function Lib.Components.Frontend.multiplayer_panel()
    return Functions.find_component("fe_multplayer_lobby_panel")
end

function Lib.Components.Frontend.custom_battle_panel()
    return Functions.find_component("fe_custom_battle_panel")
end

function Lib.Components.Frontend.quest_battle_panel()
    return Functions.find_component("fe_quest_battle_panel")
end

function Lib.Components.Frontend.battle_replays_panel()
    return Functions.find_component("fe_replays_panel")
end

function Lib.Components.Frontend.graphics_panel()
    return Functions.find_component("fe_graphics_panel")
end

function Lib.Components.Frontend.audio_panel()
    return Functions.find_component("fe_audio_panel")
end

function Lib.Components.Frontend.controls_panel()
    return Functions.find_component("fe_controls_panel")
end

function Lib.Components.Frontend.game_settings_panel()
    return Functions.find_component("fe_game_settings_panel")
end

function Lib.Components.Frontend.credits_panel()
    return Functions.find_component("fe_credits_panel")
end

function Lib.Components.Frontend.advanced_graphics_panel()
    return Functions.find_component("fe_advanced_graphics_panel")
end

function Lib.Components.Frontend.benchmark_panel()
    return Functions.find_component("fe_benchmarks_panel")
end

function Lib.Components.Frontend.campaign_selection_parent()
    return Functions.find_component("campaign_holder:campaign_button_holder:list_parent")
end

function Lib.Components.Frontend.campaign_race_selection_button()
    return Functions.find_component("campaign_select_new:right_holder:tab_lord:faction_holder:button_select_race")
end

function Lib.Components.Frontend.lord_list_parent()
    return Functions.find_component("lord_details_panel:lord_select_list:list:list_clip:list_box")
end

function Lib.Components.Frontend.lord_name_component()
    return Functions.find_component("lord_details_panel:name_and_icon_holder:name_clip:name_holder:dy_faction_leader")
end

function Lib.Components.Frontend.race_name_component()
    return Functions.find_component("side_panel_holder:button_list:lord_select_holder:button_select_lord:dy_culture_name")
end

function Lib.Components.Frontend.race_select_back_button()
    return Functions.find_component("sp_frame:frame_BL:button_home")
end

function Lib.Components.Frontend.race_select_continue_button()
    return Functions.find_component("campaign_select:continue_button_frame:button_next")
end

function Lib.Components.Frontend.race_list_parent()
    return Functions.find_component("faction_holder:button_select_race:popup_menu:list_box")
end

function Lib.Components.Frontend.playable_races_list_parent()
    return Functions.find_component("campaign_select:race_strip:playable_races:listview:list_clip:list_box")
end

function Lib.Components.Frontend.first_time_user_parent()
    return Functions.find_component("first_time_startup")
end

function Lib.Components.Frontend.first_time_user_accessibility_button()
    return Functions.find_component("first_time_startup:centre_docker:accessibility_options_parent:round_medium_button")
end

function Lib.Components.Frontend.first_time_user_main_menu_button()
    return Functions.find_component("first_time_startup:centre_docker:centre_holder:button_holder:main_menu_holder:button_main_menu")
end

function Lib.Components.Frontend.demon_prince_name_text_field()
    return Functions.find_component("name_and_icon_holder:name_clip:name_holder:name_input_holder:text_input")
end

function Lib.Components.Frontend.open_save_game_list_button()
    return Functions.find_component("campaign_frame:campaign_buttons:load_campaign:button_load_campaign")
end

function Lib.Components.Frontend.session_parent()
    return Functions.find_component("load_save_game:centre_docker:body:playthroughs:playthrough_list:list_clip:list_box")
end

function Lib.Components.Frontend.save_parent()
    return Functions.find_component("load_save_game:centre_docker:body:savegames:listview:list_clip:list_box")
end

function Lib.Components.Frontend.load_save_button()
    return Functions.find_component("load_save_game:footer:button_holder:list:button_confirm_load")
end

function Lib.Components.Frontend.frontend_menu()
    return Functions.find_component("main")
end

--## Playthrough Tracker Information Components
function Lib.Components.Frontend.session_parent_by_id(session_id)
    local path = Functions.find_path_from_component(Lib.Components.Frontend.session_parent())
    return Functions.find_component(path..":"..tostring(session_id))
end

function Lib.Components.Frontend.session_info_campaign(session_id)
    local path = Functions.find_path_from_component(Lib.Components.Frontend.session_parent_by_id(session_id))
    return Functions.find_component(path..":center:dy_campaign")
end

function Lib.Components.Frontend.session_info_faction(session_id)
    local path = Functions.find_path_from_component(Lib.Components.Frontend.session_parent_by_id(session_id))
    return Functions.find_component(path..":center:dy_faction")
end

function Lib.Components.Frontend.session_info_save_date(session_id)
    local path = Functions.find_path_from_component(Lib.Components.Frontend.session_parent_by_id(session_id))
    return Functions.find_component(path..":right:dy_date")
end

function Lib.Components.Frontend.session_info_save_time(session_id)
    local path = Functions.find_path_from_component(Lib.Components.Frontend.session_parent_by_id(session_id))
    return Functions.find_component(path..":right:dy_time")
end

function Lib.Components.Frontend.custom_battle_clear_army_button()
    return Functions.find_component("custom_battle:ready_parent:recruitment_visibility_parent:recruitment_parent:roster_holder:army_roster_parent:recruited_army_parent:army_recruitment_parent:unit_list_holder:row_header:button_bar_parent:button_list:clear_autogen_parent:button_clear")
end

function Lib.Components.Frontend.custom_battle_unit_list_parent()
    return Functions.find_component("custom_battle:ready_parent:recruitment_visibility_parent:recruitment_parent:roster_holder:army_roster_parent:recruitable_list_parent:listview:list_clip:list_box:upgrades_and_recruitment_holder:recruitment_options_list")
end

