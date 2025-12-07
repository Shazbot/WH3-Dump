


---------------------------------------------------------
-- Defines and returns some data regarding the valid
-- game environments used for generated documentation
---------------------------------------------------------


local function get_valid_environments_data()
	local valid_environments = {
		{
			environment_name = "campaign",
			environment_title = "Campaign",
			environment_path = "campaign/",
			index_file = "campaign/campaign_index.html",							-- path from document root to the index file associated with this environment
			path_to_document_root = "../",											-- path from where output files in this environment will be written to, to the document root
			icon_small = "loaded_in_campaign.png",
			navbar_background_colour_str = "fff7cc",
			navbar_header_colour_str = "ffed8c"
		},
		{
			environment_name = "battle",
			environment_title = "Battle",
			environment_path = "battle/",
			index_file = "battle/battle_index.html",								-- path from document root to the index file associated with this environment
			path_to_document_root = "../",											-- path from where output files in this environment will be written to, to the document root
			icon_small = "loaded_in_battle.png",
			navbar_background_colour_str = "e2edff",
			navbar_header_colour_str = "c1e6ff"
		},
		{
			environment_name = "frontend",
			environment_title = "Frontend",
			environment_path = "frontend/",
			index_file = "frontend/frontend_index.html",							-- path from document root to the index file associated with this environment
			path_to_document_root = "../",											-- path from where output files in this environment will be written to, to the document root
			icon_small = "loaded_in_frontend.png",
			navbar_background_colour_str = "ffece2",
			navbar_header_colour_str = "ffc8a8"
		},
		{
			environment_name = "frontpage",
			environment_title = "Script",
			environment_path = "",
			index_file = "index.html",												-- path from document root to the index file associated with this environment
			is_frontpage_environment = true,
			path_to_document_root = "",												-- path from where output files in this environment will be written to, to the document root
			navbar_background_colour_str = "f0f0f0",
			navbar_header_colour_str = "e7e7e7"
		}
	};

	return valid_environments;
end;









---------------------------------------------------------
-- Defines and returns some data regarding the
-- script documentation cluster
---------------------------------------------------------

local function define_script_documentation_cluster_data(path_from_binaries_to_script_folder, path_from_binaries_to_common_folder)

	local script_doc_cluster_data = {

		-- string name for output
		name = "script",

		-- path from common folder into which documentation will be written
		output_folder_path_appellation = "Documentation/script/",

		href_path_to_model_hierarchy_documentation = "../scripting_doc.html",

		-- generate snippets for vscode from this cluster data
		generate_snippets = true,

		path_from_binary_for_snippets = path_from_binaries_to_script_folder
	}


	-- List of files to parse for tags
	-- is_script -> file is interpreted as a lua file, with --- prepended to comments to be parsed
	-- is_code -> file is interpreted as a cpp file, with /// prepended to comments to be parsed
	script_doc_cluster_data.files_to_parse = {
		-- frontpage documentation
		{path = path_from_binaries_to_script_folder .. "docgen/content/docgen_main_index.lua",											is_script = true},
		{path = path_from_binaries_to_script_folder .. "docgen/content/docgen_main_ui_scripting.lua",									is_script = true},
	
		-- topic files
		{path = path_from_binaries_to_script_folder .. "docgen/content/campaign/docgen_campaign_index.lua",								is_script = true},
		{path = path_from_binaries_to_script_folder .. "docgen/content/campaign/docgen_campaign_script_structure.lua",					is_script = true},
		{path = path_from_binaries_to_script_folder .. "docgen/content/campaign/docgen_campaign_model_hierarchy.lua",					is_script = true},
		{path = path_from_binaries_to_script_folder .. "docgen/content/campaign/docgen_campaign_narrative.lua",							is_script = true},
		{path = path_from_binaries_to_script_folder .. "docgen/content/battle/docgen_battle_index.lua",									is_script = true},
		{path = path_from_binaries_to_script_folder .. "docgen/content/battle/docgen_battle_hierarchy.lua",								is_script = true},
		-- {path = path_from_binaries_to_script_folder .. "docgen/content/battle/docgen_battle_reinforcements.lua",						is_script = true},		-- TODO
		{path = path_from_binaries_to_script_folder .. "docgen/content/docgen_events.lua",												is_script = true},
		{path = path_from_binaries_to_script_folder .. "docgen/content/docgen_frontend_index.lua",										is_script = true},
		
		-- script libraries
		{path = path_from_binaries_to_script_folder .. "all_scripted.lua",																is_script = true},
		{path = path_from_binaries_to_script_folder .. "_lib/lib_battle_advice.lua",													is_script = true},
		{path = path_from_binaries_to_script_folder .. "_lib/lib_battle_cutscene.lua",													is_script = true},
		{path = path_from_binaries_to_script_folder .. "_lib/lib_battle_manager.lua",													is_script = true},
		{path = path_from_binaries_to_script_folder .. "_lib/lib_battle_misc.lua",														is_script = true},
		{path = path_from_binaries_to_script_folder .. "_lib/lib_battle_script_ai_planner.lua",											is_script = true},
		{path = path_from_binaries_to_script_folder .. "_lib/lib_battle_script_unit.lua",												is_script = true},
		{path = path_from_binaries_to_script_folder .. "_lib/lib_battle_ui.lua",														is_script = true},
		{path = path_from_binaries_to_script_folder .. "_lib/lib_campaign_cutscene.lua",												is_script = true},
		{path = path_from_binaries_to_script_folder .. "_lib/lib_campaign_intervention.lua",											is_script = true},
		{path = path_from_binaries_to_script_folder .. "_lib/lib_campaign_invasion_manager.lua",										is_script = true},
		{path = path_from_binaries_to_script_folder .. "_lib/lib_campaign_manager.lua",													is_script = true},
		{path = path_from_binaries_to_script_folder .. "_lib/lib_campaign_mission_manager.lua",											is_script = true},
		{path = path_from_binaries_to_script_folder .. "_lib/lib_campaign_narrative_events.lua",										is_script = true},
		{path = path_from_binaries_to_script_folder .. "_lib/lib_campaign_random_army.lua",												is_script = true},
		{path = path_from_binaries_to_script_folder .. "_lib/lib_campaign_ui.lua",														is_script = true},
		-- {path = path_from_binaries_to_script_folder .. "_lib/lib_campaign_tutorial.lua",												is_script = true},
		{path = path_from_binaries_to_script_folder .. "_lib/lib_types.lua",															is_script = true},
		{path = path_from_binaries_to_script_folder .. "_lib/lib_common.lua",															is_script = true},
		{path = path_from_binaries_to_script_folder .. "_lib/lib_convex_area.lua",														is_script = true},
		{path = path_from_binaries_to_script_folder .. "_lib/lib_core.lua",																is_script = true},
		{path = path_from_binaries_to_script_folder .. "_lib/lib_custom_context.lua",													is_script = true},
		{path = path_from_binaries_to_script_folder .. "_lib/lib_generated_battle.lua",													is_script = true},
		{path = path_from_binaries_to_script_folder .. "_lib/lib_infotext.lua",															is_script = true},
		{path = path_from_binaries_to_script_folder .. "_lib/lib_lua_extensions.lua",													is_script = true},
		{path = path_from_binaries_to_script_folder .. "_lib/lib_movie_overlay.lua",													is_script = true},
		{path = path_from_binaries_to_script_folder .. "_lib/lib_objectives.lua",														is_script = true},
		{path = path_from_binaries_to_script_folder .. "_lib/lib_script_messager.lua",													is_script = true},
		{path = path_from_binaries_to_script_folder .. "_lib/lib_timer_manager.lua",													is_script = true},
		{path = path_from_binaries_to_script_folder .. "_lib/lib_mod_loader.lua",														is_script = true},
		{path = path_from_binaries_to_script_folder .. "_lib/lib_unique_table.lua",														is_script = true},
		{path = path_from_binaries_to_script_folder .. "_lib/lib_weighted_list.lua",													is_script = true},
		{path = path_from_binaries_to_script_folder .. "_lib/lib_scripted_tours.lua",													is_script = true},
		{path = path_from_binaries_to_script_folder .. "_lib/lib_text_pointers.lua",													is_script = true},
		{path = path_from_binaries_to_script_folder .. "_lib/lib_text_pointers_active.lua",												is_script = true},
		{path = path_from_binaries_to_script_folder .. "_lib/lib_topic_leader.lua",														is_script = true},
		
		-- battle code
		{path = path_from_binaries_to_common_folder .. "EmpireBattle/Source/BattleScript/BattleEditorScriptInterface.cpp",				is_code = true},
		{path = path_from_binaries_to_common_folder .. "EmpireBattle/Source/BattleScript/BattleScriptUtilities.cpp",					is_code = true},
		{path = path_from_binaries_to_common_folder .. "EmpireBattle/Source/BattleScript/BattleScriptAssaultEquipment.cpp",				is_code = true},
		{path = path_from_binaries_to_common_folder .. "EmpireBattle/Source/BattleScript/BattleScriptAIObjective.cpp",					is_code = true},
		{path = path_from_binaries_to_common_folder .. "EmpireBattle/Source/BattleScript/BattleScriptDebugDrawing.cpp",					is_code = true},
		{path = path_from_binaries_to_common_folder .. "EmpireBattle/Source/BattleScript/BattleScriptToggleSystem.cpp",					is_code = true},
		{path = path_from_binaries_to_common_folder .. "EmpireBattle/Source/BattleScript/BattleScriptReinforcement.cpp",				is_code = true},
		{path = path_from_binaries_to_common_folder .. "EmpireBattle/Source/BattleScript/BattleScriptCompositeScenes.cpp",				is_code = true},
		
		-- ui code
		{path = path_from_binaries_to_common_folder .. "UiComponentLib/Source/LuaComponentInterface.cpp",								is_code = true},
		{path = path_from_binaries_to_common_folder .. "UIDll/Source/Campaign/CampaignUIScriptInterface.cpp",							is_code = true},
		{path = path_from_binaries_to_common_folder .. "UIDll/Source/Campaign/EmpireCampaignUI.cpp",									is_code = true},
		
		-- scripted value registry
		{path = path_from_binaries_to_common_folder .. "EmpireUtility/Source/EmpireLuaEnv.cpp",											is_code = true},
		
		-- common object
		{path = path_from_binaries_to_script_folder .. "docgen/content/campaign/docgen_campaign_common.lua",							is_script = true},
		{path = path_from_binaries_to_common_folder .. "EmpireUtility/Source/Advice.cpp",												is_code = true},
		{path = path_from_binaries_to_common_folder .. "EmpireUtility/Source/KeyboardShortcuts/KeyboardShortcutHandler.cpp",			is_code = true},
		{path = path_from_binaries_to_common_folder .. "Empire/Source/Empire.cpp",														is_code = true},
		{path = path_from_binaries_to_common_folder .. "UIDll/Source/Battle/ComponentCallbacks/OffscreenIndicator.cpp",					is_code = true},
		{path = path_from_binaries_to_common_folder .. "UIDll/Source/Common/EmpireCommonUI.cpp",										is_code = true},
		{path = path_from_binaries_to_common_folder .. "UIDll/Source/Common/LoadingScreenUI.cpp",										is_code = true},
		{path = path_from_binaries_to_common_folder .. "UIDll/Source/Common/ComponentContexts/CcoScriptObject.cpp",						is_code = true},
		
		-- campaign script
		{path = path_from_binaries_to_script_folder .. "campaign/wh2_campaign_custom_starts.lua",										is_script = true},
		{path = path_from_binaries_to_script_folder .. "campaign/faction_intro.lua",													is_script = true},

		-- frontend
		{path = path_from_binaries_to_common_folder .. "UIDll/Source/FrontEnd/FrontendUIScriptInterface.cpp",							is_code = true},
		
		-- campaign code
		{path = path_from_binaries_to_script_folder .. "docgen/content/campaign/docgen_campaign_episodic_scripting.lua",				is_script = true},
		{path = path_from_binaries_to_script_folder .. "docgen/content/campaign/docgen_campaign_cinematic_interface.lua",				is_script = true},
		
		-- narrative event data
		{path = path_from_binaries_to_script_folder .. "campaign/_narrative/wh3_narrative_system.lua",									is_script = true},
		{path = path_from_binaries_to_script_folder .. "campaign/_narrative/wh3_narrative_event_templates.lua",							is_script = true},
		{path = path_from_binaries_to_script_folder .. "campaign/_narrative/wh3_narrative_query_templates.lua",							is_script = true},
		{path = path_from_binaries_to_script_folder .. "campaign/_narrative/wh3_narrative_trigger_templates.lua",						is_script = true},

		-- scripted tour helper functions
		{path = path_from_binaries_to_script_folder .. "battle/scripted_tours/scripted_tour_helper_functions.lua",						is_script = true}
	};


	-- List of files to parse for campaign model hierarchy functions
	script_doc_cluster_data.model_hierarchy_files = {

		path_from_binaries_to_common_folder .. "EmpireCampaign/Source/Caravan/Script/CaravanScriptInterface.cpp",
		path_from_binaries_to_common_folder .. "EmpireCampaign/Source/Route/Script/RouteScriptInterfaces.cpp",

		-- path_from_binaries_to_common_folder .. "EmpireCampaign/Source/Scripting/CampaignEntityScriptUtil.cpp",
		-- path_from_binaries_to_common_folder .. "EmpireCampaign/Source/Scripting/CampaignSharedStateScriptTriggers.cpp",
		path_from_binaries_to_common_folder .. "EmpireCampaign/Source/Scripting/DilemmaScriptInterface.cpp",
		path_from_binaries_to_common_folder .. "EmpireCampaign/Source/Scripting/IncidentScriptInterface.cpp",
		path_from_binaries_to_common_folder .. "EmpireCampaign/Source/Scripting/EmpireCampaignArmoryScriptInterface.cpp",
		path_from_binaries_to_common_folder .. "EmpireCampaign/Source/Scripting/EmpireCampaignBonusValuesScriptInterface.cpp",
		path_from_binaries_to_common_folder .. "EmpireCampaign/Source/Scripting/InitiativeScriptInterface.cpp",
		path_from_binaries_to_common_folder .. "EmpireCampaign/Source/Scripting/EmpireCampaignCookingSystemScriptInterfaces.cpp",
		path_from_binaries_to_common_folder .. "EmpireCampaign/Source/Scripting/EmpireCampaignEffectScriptInterfaces.cpp",
		path_from_binaries_to_common_folder .. "EmpireCampaign/Source/Scripting/EmpireCampaignFactionCharacterTaggingScriptInterface.cpp",
		path_from_binaries_to_common_folder .. "EmpireCampaign/Source/Scripting/EmpireCampaignMilitaryForceScriptInterfaces.cpp",
		path_from_binaries_to_common_folder .. "EmpireCampaign/Source/Scripting/EmpireCampaignObservationOptionsScriptInterface.cpp",
		path_from_binaries_to_common_folder .. "EmpireCampaign/Source/Scripting/EmpireCampaignPrisonScriptingInterfaces.cpp",
		path_from_binaries_to_common_folder .. "EmpireCampaign/Source/Scripting/EmpireCampaignRitualPerformingCharacterScriptInterfaces.cpp",
		path_from_binaries_to_common_folder .. "EmpireCampaign/Source/Scripting/EmpireCampaignRitualScriptInterfaces.cpp",
		path_from_binaries_to_common_folder .. "EmpireCampaign/Source/Scripting/EmpireCampaignRitualSetupScriptInterfaces.cpp",
		path_from_binaries_to_common_folder .. "EmpireCampaign/Source/Scripting/EmpireCampaignRitualTargetScriptInterfaces.cpp",
		path_from_binaries_to_common_folder .. "EmpireCampaign/Source/Scripting/EmpireCampaignScriptInterface.cpp",
		path_from_binaries_to_common_folder .. "EmpireCampaign/Source/Scripting/EmpireCampaignUnitPurchasableEffectScriptInterfaces.cpp",
		path_from_binaries_to_common_folder .. "EmpireCampaign/Source/Scripting/EmpireCampaignWarCoordinationScriptingInterface.cpp",
		path_from_binaries_to_common_folder .. "EmpireCampaign/Source/Scripting/EmpireCampaignWindsOfMagicCompassScriptInterface.cpp",
		path_from_binaries_to_common_folder .. "EmpireCampaign/Source/Scripting/PayloadScriptInterface.cpp",
		path_from_binaries_to_common_folder .. "EmpireCampaign/Source/Scripting/PlagueScriptingInterfaces.cpp",

		path_from_binaries_to_common_folder .. "EmpireCampaign/Source/TeleportationNetwork/TeleportationNetworkScriptInterface.cpp"
	};


	script_doc_cluster_data.valid_environments = get_valid_environments_data();

	return script_doc_cluster_data;
end;














local function file_exists(path)
	local file = io.open(path, "r")
	if file then
		file:close()
		return true
	else
		return false
	end
end


local function define_docgen_data()

	-- set up some paths
	local path_from_binaries_to_script_folder = "../../warhammer/working_data/script/";
	local path_from_binaries_to_common_folder = "../../common/";
	
	if not file_exists(path_from_binaries_to_script_folder .. "docgen.lua") then
		path_from_binaries_to_script_folder = "../../../warhammer/working_data/script/";
		path_from_binaries_to_common_folder = "../../../common/";
	end
	---------------------------------------------------------
	-- Common Data
	---------------------------------------------------------

	-- Build table of common data - this does not change between different documentation clusters
	local common_data = {

		-- is our target audience the public, or internal developers
		is_public_audience = core:is_tweaker_set("GENERATE_SCRIPT_DOCGEN_FOR_PUBLIC"),

		-- paths
		path_from_binaries_to_common_folder = path_from_binaries_to_common_folder,

		-- maximum number of characters allowed for functions in navbar on left of page
		max_length_function_name_for_navbar = 48

	};


	---------------------------------------------------------
	-- Cluster Data
	---------------------------------------------------------


	local clusters = {
		define_script_documentation_cluster_data(path_from_binaries_to_script_folder, path_from_binaries_to_common_folder)
	};

	return common_data, clusters;
end;











function generate_documentation()

	-- Load docgen_main.lua, which contains the documentation engine.
	-- Error and return if loading is unsuccessful.
	if not vfs.exists("script/docgen/docgen_main.lua") then
		script_error("ERROR: generate_documentation() could not load docgen_main.lua, aborting documentation generation");
		return false;
	end;

	require("script.docgen.docgen_main");


	-- get defined data
	local common_data, clusters = define_docgen_data();

	out("@ @ @ Beginning documentation generation @ @ @");

	local generation_successful = true;
	for i = 1, #clusters do
		if not generate_documentation_cluster(common_data, clusters[i]) then
			generation_successful = false;
		end;
	end;

	if generation_successful then
		out("@ @ @ Documentation generated successfully @ @ @");
	end;

	out("");

	-- unload docgen_main.lua
	package.loaded["script.docgen.docgen_main"] = nil;

	return generation_successful;
end;


