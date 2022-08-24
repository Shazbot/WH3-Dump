load_script_libraries();

local file_name, file_path = get_file_name_and_path();

package.path = file_path .. "/?.lua;" .. package.path;
require("wh3_battle_prologue_values");
require("wh_battle_advice")

add_pause_reminder()
local can_concede = tostring(core:svr_load_string("can_concede"));

if can_concede == "0" then
	HideConcedeButton()
	YuriInvulernableWhenRouting();
else
	bm:out("Did not hide button, the variable is set to: "..can_concede)
end

-- load the wh2 intro battle script library
package.path = package.path .. ";script/battle/intro_battles/?.lua"

bm:load_scripted_tours()
bm:set_close_queue_advice(false);
bm:out("");
bm:out("********************************************************************");
bm:out("********************************************************************");
bm:out("*** Shield battle script file loaded");
bm:out("********************************************************************");
bm:out("********************************************************************");
bm:out("");


bm:register_phase_change_callback(
	"Deployed",
	function()		
		bm:queue_advisor("wh3_prologue_battle_tutorial_01_1");
		bm:add_infotext(
		1,
		"wh3_main_prologue_shield_tutorial_001",
		"wh3_main_prologue_shield_tutorial_002");
	
    end
);

-- try and load in the prologue_next_quote value from the prologue campaign
local prologue_next_quote = tostring(core:svr_load_string("prologue_next_quote"));
if prologue_next_quote then
	bm:out("prologue_next_quote is " .. tostring(prologue_next_quote));
	common.set_custom_loading_screen_text("wh3_prologue_loading_screen_quote_"..prologue_next_quote);
else
	bm:out("prologue_next_quote is not set");
end;

