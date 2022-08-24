load_script_libraries();

local file_name, file_path = get_file_name_and_path();

-- load the wh2 intro battle script library
package.path = "script/battle/intro_battles/?.lua"
require("wh2_intro_battle");

package.path = file_path .. "/?.lua;" .. package.path;

require("battle_declarations");
require("battle_phase_1_intro");
require("battle_phase_2_skirmish");
require("battle_phase_3_artillery");
require("battle_phase_4_final");


package.path = "script/battle/?.lua;" .. package.path

require("wh3_battle_prologue_values");
HideDismissResults()
AddSkipBattleText()
HideReplayButton()
AddSkipButtonListener(true)
common.enable_shortcut("toggle_pause", false)
bm:disable_time_speed_controls(true)

-- Because time controls are hidden for this battle, the game can soft-lock if they're enabled and the player mashes "ESC".
-- Pausing needs to be enabled/disabled in script instead.
core:add_listener(
	"PanelOpenedBattlePause",
	"PanelOpenedBattle",
	function(context) return context.string == "esc_menu" end,
	function()
		bm:modify_battle_speed(0)
	end,
	true
)

core:add_listener(
	"PanelClosedBattleUnpause",
	"PanelClosedBattle",
	function(context) return context.string == "esc_menu" end,
	function()
		bm:modify_battle_speed(1)
	end,
	true
)

-- Lock escape key
bm:steal_escape_key_with_callback("StopEscDuringIntro", function() out("Esc stolen") end, true)

-- Set loading screen for rematch.
core:add_listener(
	"post_battle_button_listener",
	"ComponentLClickUp",
	function(context) return context.string == "button_rematch" end,
	function() common.setup_dynamic_loading_screen("prologue_battle_1_intro", "prologue") end,
	false
)