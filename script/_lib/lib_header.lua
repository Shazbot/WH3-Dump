
local timestamp = os.clock();

-- call this here as well as in all_scripted.lua
if __game_mode ~= __lib_type_frontend then
	-- don't do this in the frontend, as we're running in the same environment so it will have already been called in all_scripted.lua
	out = remap_outputs(out, true);
end;


-- common libs
force_require("lib_lua_extensions");
force_require("lib_types");
force_require("lib_common");
force_require("lib_script_messager");
force_require("lib_timer_manager");
force_require("lib_core");
force_require("lib_custom_context");
force_require("lib_scripted_tours");
force_require("lib_text_pointers");
force_require("lib_text_pointers_active");
force_require("lib_movie_overlay");
force_require("lib_topic_leader");

if __game_mode == __lib_type_battle then
	-- battle libs	
	force_require("lib_battle_misc");
	force_require("lib_battle_manager");
	force_require("lib_battle_ui");
	force_require("lib_battle_script_unit");
	force_require("lib_battle_cutscene");
	force_require("lib_battle_patrol_manager");
	force_require("lib_battle_attack_lane_manager");
	force_require("lib_battle_script_ai_planner");
	force_require("lib_battle_project_specific");
	-- force_require("lib_battle_prelude");
	force_require("lib_objectives");
	force_require("lib_infotext");
	force_require("lib_help_pages");
	force_require("lib_tooltips");
	force_require("lib_convex_area");
	force_require("lib_generated_battle");
	force_require("lib_battle_advice");
	
elseif __game_mode == __lib_type_campaign then
	-- campaign libs
	force_require("lib_campaign_vector");
	force_require("lib_campaign_manager");
	force_require("lib_campaign_cutscene");
	force_require("lib_campaign_ui");
	force_require("lib_campaign_ui_overrides");
	force_require("lib_campaign_mission_manager");
	force_require("lib_campaign_intervention");
	force_require("lib_campaign_random_army");
	force_require("lib_campaign_invasion_manager");
	force_require("lib_objectives");
	force_require("lib_infotext");
	force_require("lib_help_pages");
	force_require("lib_tooltips");
	force_require("lib_convex_area");
	force_require("lib_weighted_list");
	force_require("lib_unique_table");
	force_require("lib_campaign_tutorial");
	force_require("lib_campaign_narrative_events");
	
elseif __game_mode == __lib_type_frontend then
	-- frontend libs
	
end;


if __game_mode == __lib_type_battle then		
	out("lib_header.lua :: script libraries reloaded in battle configuration");
elseif __game_mode == __lib_type_campaign then
	out("lib_header.lua :: script libraries reloaded in campaign configuration");
elseif __game_mode == __lib_type_frontend then
	out("lib_header.lua :: script libraries reloaded in frontend configuration");
end;

out("\tloading took " .. os.clock() - timestamp .. "s");
out("\tLua version is " .. tostring(_VERSION));
out("");



-- automatic creation of core object
core = core_object:new();
sm = script_messager:new();

-- automatically create a campaign or battle manager
if core:is_campaign() then
	cm = campaign_manager:new();
	cuim = cm:get_campaign_ui_manager();
elseif core:is_battle() then
	bm = battle_manager:new();
	cam = bm:camera();
	buim = bm:get_battle_ui_manager();
elseif core:is_frontend() then
	tm = timer_manager:new_frontend();
end;


-- load mods
force_require("lib_mod_loader");
