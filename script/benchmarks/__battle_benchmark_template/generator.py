import os
import shutil
from pathlib import Path
from xml.dom import minidom
from subprocess import Popen, PIPE

THIS_SCRIPT_FILE_PATH = os.path.abspath(__file__)
script_path = Path(THIS_SCRIPT_FILE_PATH)
WORKING_DATA_ROOT = str(script_path.parent.parent.parent.parent).replace('\\', '/') + '/'
RAW_DATA_ROOT = str(script_path.parent.parent.parent.parent.parent).replace('\\', '/') + '/raw_data/'
ASSET_GRAPH_ROOT = RAW_DATA_ROOT + 'asset_graph/'
ASSET_GRAPH_PACK_FILE_LIST_ROOT = ASSET_GRAPH_ROOT + 'pack_file_lists/'
BENCHMARK_ROOT = WORKING_DATA_ROOT + "script/benchmarks/"
BENCHMARK_GEN_DIR = WORKING_DATA_ROOT + "script/benchmarks/generated/"
BENCHMARK_TEMPLATES_ROOT = BENCHMARK_ROOT + "__battle_benchmark_template/"
BATTLES_ROOT = WORKING_DATA_ROOT + "terrain/battles/"
DEV_MAP_LIST = [ASSET_GRAPH_PACK_FILE_LIST_ROOT + 'dev/file_list.txt',
                ASSET_GRAPH_PACK_FILE_LIST_ROOT + 'dev_only/file_list.txt']


# script\benchmarks\__battle_benchmark_template\battle_benchmark.lua

def fixup_path_slashes_and_case(file_path):
    return file_path.replace('\\', '/').lower()


'''
:return all dirs in battle_root_path ex: t:/branches/warhammer3/cowboy/warhammer/working_data/terrain/battles/
'''


def get_battle_definition_dirs(battle_root_path: str) -> list[str]:
    return [x[0] for x in os.walk(battle_root_path)]


'''
:return all dirs in battle_root_path ex: t:/branches/warhammer3/cowboy/warhammer/working_data/terrain/battles/
'''


def get_battle_definitions(battle_root_path: str) -> dict:
    result = []
    bd_dirs = get_battle_definition_dirs(battle_root_path)
    print('Precessing battle_definition_dirs count::' + str(len(bd_dirs)))
    for entry in bd_dirs:
        entry = entry.lower()
        full_entry = entry + "/"
        # print("Processing::" + full_entry)
        is_valid_dir = os.path.isdir(full_entry)
        to_excluded = entry.find("_test") == -1 and entry.find("test_") == -1 and entry.find(
            "cinematic_") == -1 and entry.find("phar_main") == -1 and entry.find("troy_mythic") == -1 and entry.find(
            "troy_historical") == -1
        to_include = entry.startswith("wef_") or entry.startswith("wh3_") or entry.startswith(
            "wh2_") or entry.startswith(
            "wh_") or entry.startswith("unfortified_")
        to_include = True
        # print("Processing::" + entry + " to_excluded::" + str(to_excluded) + " to_include::" + str(to_include))
        if is_valid_dir and to_excluded and to_include:
            bd = {"full_path": full_entry, "wd_rel_path": full_entry[len(WORKING_DATA_ROOT):],
                  "battle_name": os.path.basename(entry), "catchment_areas": set()}
            blm_path = full_entry + "battle_locations_map.xml"
            if os.path.exists(blm_path):
                with open(blm_path, "rt") as f:
                    buffer = f.read()
                    buffer = buffer.replace("indices='-1'", "")  # Duplicate attributes
                    with open("c:\\temp\\buffer.txt", "w") as text_file:
                        text_file.write(buffer)
                    doc = minidom.parseString(buffer)
                    catchment_areas = doc.getElementsByTagName("CATCHMENT_AREA")
                    for area in catchment_areas:
                        area_name = area.getAttribute("name")
                        bd["catchment_areas"].add(area_name)
                    doc.unlink()
            result.append(bd)
    return result


def sync_asset_graph(asset_graph_root_path: str) -> None:
    args = ["p4", "sync", '-f', asset_graph_root_path + '...']
    print("sync asset graph :" + " ".join(args))
    # result = subprocess.run(args, shell=True, capture_output=True, text=True)
    with Popen(args, stdout=PIPE, text=True) as process:
        for line in process.stdout:
            print(line.strip())
    # print("Output:", result.stdout)
    # print("Return code:", result.returncode)


'''
:return set of dev and dev_only  from asset graph in order to be excluded  
'''


def load_dev_maps(file_lists: list[str]) -> set[str]:
    result = set()
    for file_list in file_lists:
        if os.path.exists(file_list):
            with open(file_list) as file:
                for line in file:
                    l = line.rstrip().lower()
                    result.add(l)
        else:
            print("ERROR file do not exists::" + file_list)
    return result


'''
:return set of maps name to be excluded (one map at line)  
'''


def load_maps_to_exclude(file_name='maps_to_exclude.txt') -> set[str]:
    result = set()
    file_path = os.path.join(script_path.parent, file_name)
    # print("maps_to_exclude::"+file_path)
    if os.path.exists(file_path):
        with open(file_path) as file:
            for line in file:
                l = line.rstrip().lower()
                result.add(l)
    return result


'''
Enumerates  all dirs in  BATTLES_ROOT::D:/branches/warhammer3/cowboy/warhammer/working_data/terrain/battles/
search fo battle_locations_map.xml reads all CATCHMENT_AREA element

'''
if __name__ == "__main__":
    sync_asset_graph(ASSET_GRAPH_ROOT)
    print("THIS_SCRIPT_FILE_PATH::" + THIS_SCRIPT_FILE_PATH)
    print("script_path::" + str(script_path))
    print("WORKING_DATA_ROOT::" + WORKING_DATA_ROOT)
    print("BENCHMARK_ROOT::" + BENCHMARK_ROOT)
    print("BENCHMARK_GEN_DIR::" + BENCHMARK_GEN_DIR)
    print("BENCHMARK_TEMPLATES_ROOT::" + BENCHMARK_TEMPLATES_ROOT)
    print("BATTLES_ROOT::" + BATTLES_ROOT)
    print("RAW_DATA_ROOT::" + RAW_DATA_ROOT)
    print("ASSET_GRAPH_ROOT::" + ASSET_GRAPH_ROOT)
    print("ASSET_GRAPH_PACK_FILE_LIST_ROOT::" + ASSET_GRAPH_PACK_FILE_LIST_ROOT)
    print("DEV_MAP_LIST::" + str(DEV_MAP_LIST))
    dev_maps = load_dev_maps(DEV_MAP_LIST)
    print('dev_maps asset graph etriers::' + str(len(dev_maps)))
    exclude_maps = load_maps_to_exclude()
    print('maps name to be excluded::' + str(len(exclude_maps)))

    template_benchmark_xml = minidom.parse(BENCHMARK_TEMPLATES_ROOT + "battle_benchmark.xml")
    battle_map_definition_name_el = template_benchmark_xml.getElementsByTagName("battle_map_definition")[0].childNodes[
        1].firstChild
    battle_script_name_el = template_benchmark_xml.getElementsByTagName("battle_script")[0].firstChild
    catchment_area_name_el = template_benchmark_xml.getElementsByTagName("battle_map_definition")[0].childNodes[
        3].firstChild

    shutil.rmtree(BENCHMARK_GEN_DIR,ignore_errors=True)
    os.makedirs(BENCHMARK_GEN_DIR, exist_ok=True)
    battle_definitions = get_battle_definitions(BATTLES_ROOT)

    skipped_counter = 0
    skipped_counter_due_to_missing_tile_map = 0
    catchment_areas_counter = 0
    not_catchment_areas_counter = 0
    non_catchment_areas_list = []
    catchment_areas_list = []
    for battle_def in battle_definitions:
        key = 'terrain/battles/' + battle_def['battle_name'] + '/tile_map.bmd'
        if key in dev_maps or battle_def["battle_name"] in exclude_maps:
            # print("skipped::" + str(battle_def))
            skipped_counter += 1
            continue
        battle_map_definition_name_el.data = battle_def["wd_rel_path"]
        if battle_def["catchment_areas"]:
            # catchment_areas->{'full_path': 't:/branches/warhammer3/cowboy/warhammer/working_data/terrain/battles/wh3_major_b_01_small/', 'wd_rel_path': 'terrain/battles/wh3_major_b_01_small/', 'battle_name': 'wh3_major_b_01_small', 'catchment_areas': {'catchment_01'}}
            # print("catchment_areas->" + str(battle_def))
            catchment_areas_list.append(battle_def)
            for area in battle_def["catchment_areas"]:
                full_name = battle_def["battle_name"] + "_" + area
                new_benchmakr_base_dir = BENCHMARK_GEN_DIR + full_name + "/"
                catchment_areas_counter += 1
                os.makedirs(new_benchmakr_base_dir, exist_ok=True)

                lua_file_path = new_benchmakr_base_dir + full_name + ".lua"
                with open(lua_file_path, "wt") as f:
                    f.write("require('script/benchmarks/__battle_benchmark_template/battle_benchmark')")

                battle_script_name_el.data = lua_file_path[len(WORKING_DATA_ROOT):]
                catchment_area_name_el.data = area

                xml_file_path = new_benchmakr_base_dir + full_name + ".xml"
                with open(xml_file_path, "wt") as f:
                    f.write(template_benchmark_xml.toxml(encoding="UTF-8").decode("UTF-8"))
        else:
            new_benchmakr_base_dir = BENCHMARK_GEN_DIR + battle_def["battle_name"] + "/"
            tile_map_path = battle_def["full_path"] + "/tile_map.bmd"
            tile_map_exists = os.path.exists(tile_map_path)
            if not tile_map_exists:
                skipped_counter_due_to_missing_tile_map += 1
                continue
            # print("not catchment_areas->" +  str(battle_def))
            non_catchment_areas_list.append(battle_def)
            not_catchment_areas_counter += 1
            try:
                full_name = battle_def["battle_name"]
                os.makedirs(new_benchmakr_base_dir, exist_ok=True)
                lua_file_path = new_benchmakr_base_dir + full_name + ".lua"
                with open(lua_file_path, "wt") as f:
                    f.write("require('script/benchmarks/__battle_benchmark_template/battle_benchmark')")
                # print("write to::"+lua_file_path)

                battle_script_name_el.data = lua_file_path[len(WORKING_DATA_ROOT):]
                catchment_area_name_el.data = ""

                xml_file_path = new_benchmakr_base_dir + full_name + ".xml"
                with open(xml_file_path, "wt") as f:
                    f.write(template_benchmark_xml.toxml(encoding="UTF-8").decode("UTF-8"))
            except Exception as e:
                print('An exception occurred: {}'.format(e))
    # print('benchmarks generated::' + str(catchment_areas_counter + not_catchment_areas_counter))
    # print('benchmarks generated::' + str(catchment_areas_counter + not_catchment_areas_counter))
    print('catchment_areas_counter::' + str(catchment_areas_counter))
    print('not_catchment_areas_counter::' + str(not_catchment_areas_counter))
    print('skipped dev maps::' + str(skipped_counter))
    print('skipped  missing tile_map.bmd::' + str(skipped_counter_due_to_missing_tile_map))
    print('total generated::' + str(catchment_areas_counter + not_catchment_areas_counter))
