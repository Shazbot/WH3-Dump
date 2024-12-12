

out("");
out("*** test_script_here.lua loaded - if you want to add test scripts to campaign, battle or the frontend, see the lua file working_data\\script\\_lib\\mod\\test_script_here.lua ***");
out("");







-----------------------------------------------------
-- BATTLE TEST SCRIPTS
-----------------------------------------------------


-- Test scripts placed here will be called when the battle script environment is started - this happens
-- right at the end of the loading sequence in to any battle
function battle_startup_test_scripts_here()
	-- script_error("battle_startup_test_scripts_here() called");

	-- test scripts here
end;


-- Test scripts placed here will be called in battle when deployment phase commences
function battle_deployment_test_scripts_here()
	-- script_error("battle_deployment_test_scripts_here() called");

	-- test scripts here
end;


-- Test scripts placed here will be called in battle when the conflict phase commences
function battle_conflict_test_scripts_here()
	-- script_error("battle_conflict_test_scripts_here() called");
	
	-- test scripts here
end;







-----------------------------------------------------
-- CAMPAIGN TEST SCRIPTS
-----------------------------------------------------


--
--
-- Test scripts placed here will be called when the first tick is received in campaign, which is when the game becomes interactive
function campaign_first_tick_test_script_here()
	-- script_error("campaign_first_tick_test_script_here() called");

	-- test scripts here
end;








-----------------------------------------------------
-- FRONTEND TEST SCRIPTS
-----------------------------------------------------


--
--
-- Test scripts placed here will be called when the UI is loaded in the frontend
function frontend_ui_loaded_test_scripts_here()
	-- script_error("frontend_ui_loaded_test_scripts_here() called");
	
	-- test scripts here
end;













-----------------------------------------------------
-- LISTENERS
-----------------------------------------------------

if core:is_battle() then
	-- in battle, the script is loaded last, so just call the test functions
	battle_startup_test_scripts_here();
	bm:register_phase_change_callback("Deployment", battle_deployment_test_scripts_here);
	bm:register_phase_change_callback("Deployed", battle_conflict_test_scripts_here);

elseif core:is_campaign() then
	-- test_script_here() will be automatically called when FirstTickAfterWorldCreated event is received
	function test_script_here() 
		campaign_first_tick_test_script_here()
	end;

elseif core:is_frontend() then
	-- frontend scripts generally start when UI is created
	core:add_ui_created_callback(frontend_ui_loaded_test_scripts_here);
end;