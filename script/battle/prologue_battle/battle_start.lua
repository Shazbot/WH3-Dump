load_script_libraries();

local file_name, file_path = get_file_name_and_path();

package.path = file_path .. "/?.lua;" .. package.path;

bm:set_close_queue_advice(false);
bm:out("");
bm:out("********************************************************************");
bm:out("********************************************************************");
bm:out("*** WH3 Prologue battle script file loaded");
bm:out("********************************************************************");
bm:out("********************************************************************");
bm:out("");

require("wh3_battle_prologue_values");
require("wh_battle_advice");

local can_concede = tostring(core:svr_load_string("can_concede"));

if can_concede == "0" then
	HideConcedeButton()
	YuriInvulernableWhenRouting();
else
	bm:out("Did not hide button, the variable is set to: "..can_concede)
end


-- try and load in the prologue_next_quote value from the prologue campaign
local prologue_next_quote = tostring(core:svr_load_string("prologue_next_quote"));
if prologue_next_quote then
	bm:out("prologue_next_quote is " .. tostring(prologue_next_quote));
	common.set_custom_loading_screen_text("wh3_prologue_loading_screen_quote_"..prologue_next_quote);
else
	bm:out("prologue_next_quote is not set");
end;




bm:load_scripted_tours();


