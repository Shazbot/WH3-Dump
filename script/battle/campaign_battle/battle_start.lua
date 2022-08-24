load_script_libraries();

local file_name, file_path = get_file_name_and_path();

package.path = file_path .. "/?.lua;" .. package.path;

bm:set_close_queue_advice(false);
bm:out("");
bm:out("********************************************************************");
bm:out("********************************************************************");
bm:out("*** Campaign battle script file loaded");
bm:out("********************************************************************");
bm:out("********************************************************************");
bm:out("");

require("wh_battle_advice");

bm:load_scripted_tours();