import sys
import json
import os
import db_roots as wh3_xml_roots
import generate_lua_tables
import xml.etree.ElementTree as ET
from pathlib import Path
from xml.dom import minidom
from xml.dom.minidom import Node

def get_frontend_faction_key(lord_index):
	start_pos_starting_general_options_database = wh3_xml_roots.get_start_pos_starting_general_options_root()
	for entry in start_pos_starting_general_options_database.iter("start_pos_starting_general_options"):
		if entry.find("general").text == lord_index:
			return entry.find("frontend_faction_leader").text


def get_faction_key(frontend_faction_key):
	frontend_faction_leaders_database = wh3_xml_roots.get_frontend_faction_leaders_root()
	for entry in frontend_faction_leaders_database.iter("frontend_faction_leaders"):
		if entry.find("key").text == frontend_faction_key:
			return entry.find("faction").text

def get_faction_name(faction_key):
	factions_database = wh3_xml_roots.get_factions_root()
	for entry in factions_database.iter("factions"):
		if entry.find("key").text == faction_key:
			return entry.find("screen_name").text


def get_starting_army_data(lord_name, lord_index):
	'''
	Generates and returns the Starting Army portion of the context dict.
	This includes the units and the leader unit.
	'''
	skaven_lords = [
		"Queek Headtaker",
		"Lord Skrolk",
		"Tretch Craventail",
		"Ikit Claw",
		"Deathmaster Snikch"
	]

	army_data = {}
	army_data["Leader"] = lord_name
	army_data["Units"] = []
	starting_land_units_database = wh3_xml_roots.get_start_pos_land_units_root()
	main_units_database = wh3_xml_roots.get_main_units_root()
	land_units_database = wh3_xml_roots.get_land_units_root()
	for unit in land_units_database.iter("land_units"):
		if lord_name in unit.find("onscreen_name").text.replace(",", "") and "_0" in unit.get("record_key"):
			army_data["Units"].append({
					"unit_key": unit.get("record_key"),
					"unit_name": unit.find("onscreen_name").text,
					"unit_category": unit.find("category").text,
					"unit_class": unit.find("class").text,
			})
			lord_name = unit.find("onscreen_name").text
			break
		else:
			for skv_lord in skaven_lords:
				if unit.find("onscreen_name").text.replace(",", "") == skv_lord and lord_name == skv_lord:
					army_data["Units"].append({
							"unit_key": unit.get("record_key"),
							"unit_name": unit.find("onscreen_name").text,
							"unit_category": unit.find("category").text,
							"unit_class": unit.find("class").text,
					})
					lord_name = unit.find("onscreen_name").text
					break

	for entry in starting_land_units_database.iter("start_pos_land_units"):
		if entry.find("general").text == lord_index:
			unit_key = entry.find("unit_type").text
			for main_unit in main_units_database.iter("main_units"):
				if unit_key == main_unit.get("record_key"):
					new_unit_key = main_unit.find("land_unit").text
					for land_unit in land_units_database.iter("land_units"):
						if new_unit_key == land_unit.get("record_key"):
							army_data["Units"].append({
									"unit_key": new_unit_key,
									"unit_name": land_unit.find("onscreen_name").text,
									"unit_category": land_unit.find("category").text,
									"unit_class": land_unit.find("class").text,
							})
	
	return army_data

def generate_json_file(data, campaign_type):
	'''
	Takes a context dict (data) and generates a josn file on the ca-data\\tw\\Automation\\WH3 network location.
	File name contains the Lord Name that was parsed in.
	'''

	base_path = r"\\ca-data\tw\Automation\WH3\Dev\faction_load_test"
	if campaign_type == "chaos_realms":
		base_path = os.path.join(base_path, "Chaos_Realms", data["Lord_Name"].replace(" ", "_"))
	elif campaign_type == "immortal_empires":
		base_path = os.path.join(base_path, "Immortal_Empires", data["Lord_Name"].replace(" ", "_"))
	
	json_path = base_path+".json"
	print(json_path)
	with open(json_path, 'w') as outfile:
		json.dump(data, outfile, indent=4)

def generate_lua_table(data, campaign_type):
	'''
	Takes a context dict (data) and generates a lua table file in the "Context_Tables" folder on the desktop. (will create if one does not exist) 
	File name contains the Lord Name that was parsed in.
	'''

	context_path = os.path.expanduser(r'~\Desktop\Context_Tables')
	if not os.path.exists(context_path):
		os.makedirs(context_path)
	if campaign_type == "chaos_realms":
		base_path = os.path.join(context_path, "CR_temp_table_"+data["Lord_Name"].replace(" ", "_"))
	elif campaign_type == "immortal_empires":
		base_path = os.path.join(context_path, "IE_temp_table_"+data["Lord_Name"].replace(" ", "_"))

	lua_path = base_path+".lua"
	print(lua_path)


	generate_lua_tables.create_faction_load_test_lua_table(lua_path, data)

def get_faction_data(lord_name, lord_index):
	'''
	Builds a dict for the given lord based off the data grabbed from the database xml files stored in the raw_data/db location.
	'''

	frontend_faction_key = get_frontend_faction_key(lord_index)
	faction_key = get_faction_key(frontend_faction_key)
	faction_name = get_faction_name(faction_key)
	starting_army_data = get_starting_army_data(lord_name, lord_index)

	data = {
		"Faction_Name": faction_name,
		"Faction_Key": faction_key,
		"Frontend_Faction_Key": frontend_faction_key,
		"Leader_Index": lord_index,
		"Lord_Name": lord_name,
		"Starting_Army": starting_army_data
	}

	return data

# Arguments parsed in via the command line.
file_type = sys.argv[1]
lord_arg = sys.argv[2]
lord_index_arg = sys.argv[3]
campaign_type_arg = sys.argv[4]

# Script execution begins here
if __name__ == "__main__":
	if file_type == "json":
		faction_data = get_faction_data(lord_arg, lord_index_arg)
		generate_json_file(faction_data, campaign_type_arg)
	elif file_type == "lua":
		faction_data = get_faction_data(lord_arg, lord_index_arg)
		generate_lua_table(faction_data, campaign_type_arg)