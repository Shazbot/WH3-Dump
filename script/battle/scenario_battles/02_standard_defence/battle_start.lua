

load_script_libraries();


if core:is_tweaker_set("SCRIPTED_TWEAKER_05") then
	script_error("SCRIPTED_TWEAKER_05 is set, so not loading script for this battle");
	bm:camera():fade(false, 1);
	return;
end;



local file_name, file_path = get_file_name_and_path();

-- load the wh2 intro battle script library
package.path = "script/battle/intro_battles/?.lua"
require("wh2_intro_battle");

package.path = file_path .. "/?.lua;" .. package.path;

require("battle_declarations");
require("battle_deployment");
require("battle_deployment_st");
require("battle_main");

package.path = "script/battle/?.lua;" .. package.path

require("wh3_battle_prologue_values");
HideDismissResults()
AddSkipBattleText()
HideReplayButton()
AddSkipButtonListener(false)
add_pause_reminder()
core:remove_listener("ComponentLClickUpCheckForPausedBattle");
common.enable_shortcut("toggle_pause", false)

-- Set loading screen for rematch.
core:add_listener(
	"post_battle_button_listener",
	"ComponentLClickUp",
	function(context) return context.string == "button_rematch" end,
	function() common.setup_dynamic_loading_screen("prologue_battle_2_intro", "prologue") end,
	false
)