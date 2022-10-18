# This is a script to find all callback files in the game's directory

import os # Looking for filepaths
from pathlib import Path # Looking for filepaths
from collections import defaultdict # Create default dict for filepaths
import re # Search for callback files
import pickle # Allows us to save a python dictionary of the paths to be loaded by another script
import sys # Redirect output to a text file so it's searchable
dirname = os.path.dirname(__file__)
sys.stdout = open(os.path.join(dirname, "PythonDebugOutput.txt"), "w")

root = Path.cwd().root

CALLBACK_H_FILE_REGEX = re.compile("[cC]allback(s)?.h")
COMMON_GROUPS = ["Battle", "Campaign", "Frontend", "Context", "Common"]

def get_group_from_filepath(path, filename):
    """
    Sorts callback into one of the common groups based on the filepath - looking first at the path (for example if in Battle folder) and then at the filename (for example ComponentCONTEXTCallbacks)
    """
    for group in COMMON_GROUPS:
        if group.lower() in path.lower():
            return group
    for group in COMMON_GROUPS:
        if group.lower() in filename.lower():
            return group
    return "Common"

def find_cpp_file_for_h_file(path, filename):
    """
    h files and cpp files for the same callbacks are not always in the same directory
    knowing an h file path, this function will find the corresponding cpp file path
    """
    filename_cpp = filename.replace(".h", ".cpp")
    while path != root:
        # Check first all files and subdirectories in current directory
        for folder, dirs, files in os.walk(path):
            for file in files:
                if filename_cpp == file: # We found our cpp ile!
                    return os.path.join(folder, file)
        else:
            # Don't search above "common", as we risk searching different projects' directories!
            if str(path).endswith("common"):
                raise Exception(f"Could not find .cpp file relating to .h callback file {filename}!")
            path = path.parent
            continue
        break

def get_paths_to_uidll_and_uicomponentlib():
    """
    We search the UIDll and UiComponentLib directories for callbacks
    So first we have to locate them starting from cwd
    """
    path_to_uidll = Path.cwd()
    path_to_uicomponentlib = path_to_uidll
    while path_to_uidll != root:
        print("Searching path: ", path_to_uidll)
        for folder, dirs, files in os.walk(path_to_uidll):
            # Look in all subdirs until finding one that contains UIDll and UiComponentLib
            if "UIDll" in dirs and "UiComponentLib" in dirs:
                if os.path.isdir(folder + "/UIDll/") and os.path.isdir(folder + "/UiComponentLib/"):
                    path_to_uicomponentlib = folder + "/UiComponentLib/"
                    path_to_uidll = folder + "/UIDll/"
                    break
        else:
            if str(path_to_uidll).endswith("common"):
                raise Exception("Could not find UiDll and UiComponentLib directories!")
            path_to_uidll = path_to_uidll.parent
            continue
        break
    print("Found paths! To UIDll: ", path_to_uidll, " and UiComponentLib: ", path_to_uicomponentlib)
    return path_to_uidll, path_to_uicomponentlib

def get_last_meaningful_folder(path):
    """
    Returns last folder in this path, unless that folder is just called "callbacks" or "component callbacks", then we return the folder before it
    This helps us know if the callback file is for example in a folder called "battle"
    (We don't just search the entire path because then everything would go into Common!)
    """
    group = re.split("\\\\|/", path)
    if group[-1].lower().endswith("callbacks"):
        return get_last_meaningful_folder("/".join(group[:-1]))
    else:
        return group[-1]


def get_all_callback_files_in_dir(path, filepaths):
    """
    After finding the UIDll and UiComponentLib dirs, we want to search them for callback files
    This matches all .h files either:
    - in folders that end in Callbacks
    - their name ends in "callback" or "callbacks"
    Matching a non-callback file is not a huge problem, the parser will look into it and return nothing
    """
    for folder, dirs, files in os.walk(path):
        folder_is_for_callbacks = folder.lower().endswith("callbacks")
        for file in files:
            should_add_to_filepaths = (folder_is_for_callbacks and file.endswith(".h")) or CALLBACK_H_FILE_REGEX.search(file) is not None
            if should_add_to_filepaths:
                fullpath = os.path.join(folder, file)
                group = get_group_from_filepath(get_last_meaningful_folder(folder), file)
                filepaths[group].append((fullpath, find_cpp_file_for_h_file(Path(folder), file)))

def get_all_callback_filepaths():
    """
    Function to find all filepaths, can be imported and called from another file
    Will return a dict mapping callback files to their group (Battle, Campaign...)
    """
    filepaths = defaultdict(list)

    path_to_uidll, path_to_uicomponentlib = get_paths_to_uidll_and_uicomponentlib()
    get_all_callback_files_in_dir(path_to_uidll, filepaths)
    get_all_callback_files_in_dir(path_to_uicomponentlib, filepaths)
    
    return filepaths

def get_pickle_save_path():
    """
    We want to save our picle file containing our filepaths into working_data/documentation/ui/
    """
    path_to_pickle = Path.cwd()
    while path_to_pickle != root:
        print("Searching pickle path: ", path_to_pickle)
        for folder, dirs, files in os.walk(path_to_pickle):
            # Look in all subdirs until finding one that contains working_data/UI/
            if "working_data" in dirs:
                if os.path.isdir(folder + "/working_data/documentation/ui/"):
                    path_to_pickle = folder + "/working_data/documentation/ui/filepaths.pkl"
                    break
        else:
            if str(path_to_pickle).endswith("common"):
                raise Exception("Could not find working data ui directory!")
            path_to_pickle = path_to_pickle.parent
            continue
        break
    print("Found path! ", path_to_pickle)
    return path_to_pickle

def save_all_callbacks_to_pickle_file():
    """
    Calls get_all_callback_filepaths() and then saves those filepaths to a pickle file
    """
    filepaths = get_all_callback_filepaths()
    save_path = get_pickle_save_path()
    with open(save_path, 'wb') as file:
        pickle.dump(filepaths, file)