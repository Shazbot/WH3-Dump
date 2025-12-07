import os;
from pathlib import Path
from xml.dom import minidom;

THIS_SCRIPT_FILE_PATH = os.path.realpath(__file__)
script_path = Path(THIS_SCRIPT_FILE_PATH)
# WORKING_DATA_ROOT = "T:/branches/phar/dev/warhammer/working_data/";
WORKING_DATA_ROOT = str(script_path.parent.parent.parent.parent.absolute()).replace('\\', '/') + '/'
BENCHMARK_ROOT = WORKING_DATA_ROOT + "script/benchmarks/";
BENCHMARK_TEMPLATES_ROOT = BENCHMARK_ROOT + "__battle_benchmark_template/";
BATTLES_ROOT = WORKING_DATA_ROOT + "terrain/battles/";


# script\benchmarks\__battle_benchmark_template\battle_benchmark.lua

def fixup_path_slashes_and_case(file_path):
    return file_path.replace('\\', '/').lower();


if __name__ == "__main__":
    print("THIS_SCRIPT_FILE_PATH::" + THIS_SCRIPT_FILE_PATH)
    print("script_path::" + str(script_path))
    print("WORKING_DATA_ROOT::" + WORKING_DATA_ROOT)
    print("BENCHMARK_ROOT::" + BENCHMARK_ROOT)
    print("BENCHMARK_TEMPLATES_ROOT::" + BENCHMARK_TEMPLATES_ROOT)
    print("BATTLES_ROOT::" + BATTLES_ROOT)
    template_benchmark_xml = minidom.parse(BENCHMARK_TEMPLATES_ROOT + "battle_benchmark.xml");
    battle_map_definition_name_el = template_benchmark_xml.getElementsByTagName("battle_map_definition")[0].childNodes[
        1].firstChild;
    battle_script_name_el = template_benchmark_xml.getElementsByTagName("battle_script")[0].firstChild;
    catchment_area_name_el = template_benchmark_xml.getElementsByTagName("battle_map_definition")[0].childNodes[
        3].firstChild;

    battle_definitions = [];
    for entry in os.listdir(BATTLES_ROOT):
        entry = entry.lower();
        full_entry = BATTLES_ROOT + entry + "/";
        #print("Processing::" + entry)
        is_valid_dir = os.path.isdir(full_entry)
        to_excluded = entry.find("_test") == -1 and entry.find("test_") == -1 and entry.find(
            "cinematic_") == -1 and entry.find("phar_main") == -1 and entry.find("troy_mythic") == -1 and entry.find(
            "troy_historical") == -1
        to_include = entry.startswith("wef_") or entry.startswith("wh3_") or entry.startswith("wh2_") or entry.startswith(
            "wh_") or entry.startswith("unfortified_")
        to_include = True
        print("Processing::" + entry + " to_excluded::" + str(to_excluded) + " to_include::" + str(to_include))
        if is_valid_dir and to_excluded and to_include:
            battle_def = {};
            battle_def["full_path"] = full_entry;
            battle_def["wd_rel_path"] = full_entry[len(WORKING_DATA_ROOT):];
            battle_def["battle_name"] = entry;
            battle_def["catchment_areas"] = set();

            blm_path = full_entry + "battle_locations_map.xml";
            if os.path.exists(blm_path):
                #print("blm_path ->" +blm_path);
                with open(blm_path, "rt") as f:
                    buffer = f.read();
                    buffer = buffer.replace("indices='-1'", "");  # Duplicate attributes
                    with open("c:\\temp\\buffer.txt", "w") as text_file:
                        text_file.write(buffer)
                    doc = minidom.parseString(buffer);
                    catchment_areas = doc.getElementsByTagName("CATCHMENT_AREA");
                    for area in catchment_areas:
                        battle_def["catchment_areas"].add(area.getAttribute("name"));
                    doc.unlink();

            battle_definitions.append(battle_def);

    for battle_def in battle_definitions:
        battle_map_definition_name_el.data = battle_def["wd_rel_path"];
        if battle_def["catchment_areas"]:
            for area in battle_def["catchment_areas"]:
                full_name = battle_def["battle_name"] + "_" + area;
                new_benchmakr_base_dir = BENCHMARK_ROOT + "generated/" + full_name + "/";
                print("has catchment_areas->" + new_benchmakr_base_dir);
                os.makedirs(new_benchmakr_base_dir, exist_ok=True);

                lua_file_path = new_benchmakr_base_dir + full_name + ".lua";
                with open(lua_file_path, "wt") as f:
                    f.write("require('script/benchmarks/__battle_benchmark_template/battle_benchmark')");

                battle_script_name_el.data = lua_file_path[len(WORKING_DATA_ROOT):];
                catchment_area_name_el.data = area;

                xml_file_path = new_benchmakr_base_dir + full_name + ".xml"
                with open(xml_file_path, "wt") as f:
                    f.write(template_benchmark_xml.toxml(encoding="UTF-8").decode("UTF-8"));
        else:
            new_benchmakr_base_dir = BENCHMARK_ROOT + "generated/" + battle_def["battle_name"] + "/";
            print("not catchment_areas->" + new_benchmakr_base_dir);
            try:
                full_name = battle_def["battle_name"]
                os.makedirs(new_benchmakr_base_dir, exist_ok=True);
                lua_file_path = new_benchmakr_base_dir + full_name + ".lua";
                with open(lua_file_path, "wt") as f:
                    f.write("require('script/benchmarks/__battle_benchmark_template/battle_benchmark')");
                #print("write to::"+lua_file_path)

                battle_script_name_el.data = lua_file_path[len(WORKING_DATA_ROOT):];
                catchment_area_name_el.data = "";

                xml_file_path = new_benchmakr_base_dir + full_name + ".xml"
                with open(xml_file_path, "wt") as f:
                    f.write(template_benchmark_xml.toxml(encoding="UTF-8").decode("UTF-8"));
            except Exception as e:
                print('An exception occurred: {}'.format(e))
