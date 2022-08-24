import sys
import time
import itertools
import threading
import os
import csv
import json
import db_roots as wh3_xml_roots
import unit_check_functions as UT
from pathlib import Path
from datetime import datetime
from colorama import init, Fore

init(autoreset=True)

def rename_output_log(new_name):
	output_log_folder_path = Path(os.path.expanduser(r'~\AppData\Roaming\CA_Autotest\WH3\battle_verification'))
	output_log_file_name = "output_log.txt"
	output_log_file_path = os.path.join(output_log_folder_path, output_log_file_name)
	if os.path.exists(output_log_file_path):
		os.rename(output_log_file_path, os.path.join(output_log_folder_path, new_name+".txt"))


unit_fieldnames = [
		"Unit Key",
		"Unit Name",
		"Unit Class",
		"Unit HP",
		"Armour",
		"Leadership",
		"Speed",
		"Melee Attack",
		"Melee Defence",
		"Weapon Strength",
		"Charge Bonus",
	]

def get_set_faction_unit_data(faction_key):
	unit_data = {}
	unit_data["Units"] = []
	land_units_db_root = wh3_xml_roots.get_land_units_root()
	battle_entities_db_root = wh3_xml_roots.get_battle_entities_root()
	for land_unit in land_units_db_root.iter("land_units"):
		if faction_key in land_unit.get("record_key"):
			man_entity = land_unit.find("man_entity").text
			entity_hp = 0
			enitiy_speed = 0
			for entity in battle_entities_db_root.iter("battle_entities"):
				if man_entity in entity.get("record_key"):
					entity_hp = int(entity.find("hit_points").text) + int(land_unit.find("bonus_hit_points").text)
					enitiy_speed = int(round(float(entity.find("run_speed").text), 1) * 10)
					break
			unit_data["Units"].append({
					"Unit Key": land_unit.find("key").text,
					"Unit Name": land_unit.find("onscreen_name").text,
					"Unit Class": land_unit.find("class").text,
					"Unit HP": entity_hp,
					"Armour": UT.get_armour_value(land_unit.find("armour").text),
					"Leadership": land_unit.find("morale").text,
					"Speed": enitiy_speed,
					"Melee Attack": land_unit.find("melee_attack").text,
					"Melee Defence": land_unit.find("melee_defence").text,
					"Weapon Strength": UT.get_weapon_strength_value(land_unit.find("primary_melee_weapon").text),
					"Charge Bonus": land_unit.find("charge_bonus").text,
			})
	return unit_data


def write_csv_row(InputDict):
	csv_folder_path = Path(os.path.expanduser(r'~\AppData\Roaming\CA_Autotest\WH3\battle_verification'))
	in_game_csv_file_stem = Path(results_file_path).stem
	csv_file_name = in_game_csv_file_stem+"_db_values_file.csv"
	csv_file_path = os.path.join(csv_folder_path, csv_file_name)
	with open(csv_file_path, mode='a', newline='') as csv_file:
		writer = csv.DictWriter(csv_file, fieldnames=unit_fieldnames)
		writer.writeheader()
		writer.writerows(InputDict["Units"])
		sys.stdout.write("\rWriting data to CSV "+ Fore.GREEN +"COMPLETE	\n")

def check_csv_data(unit_data, path):
	path_to_str = str(path)
	test_path = Path(path_to_str).stem
	f = open(path_to_str)
	csv_f = csv.DictReader(f)
	for ingame_values in csv_f:
		for db_values in unit_data["Units"]:
			if ingame_values["Unit Key"] == db_values["Unit Key"]:
				print("Running Database comparison on Unit - "+ingame_values["Unit Name"])
				UT.write_to_output_log("Running Database comparison on Unit - "+ingame_values["Unit Name"])
				UT.check_unit_name(ingame_values["Unit Name"], db_values["Unit Name"])
				UT.check_unit_class(ingame_values["Unit Class"], db_values["Unit Class"])
				UT.check_unit_HP(ingame_values["Unit HP"], db_values["Unit HP"], ingame_values["Entity Count"], ingame_values["Unit Scale"])
				UT.check_unit_armour(ingame_values["Armour"], db_values["Armour"])
				UT.check_unit_leadership(ingame_values["Leadership"], db_values["Leadership"])
				UT.check_unit_speed(ingame_values["Speed"], db_values["Speed"])
				UT.check_unit_melee_attack(ingame_values["Melee Attack"], db_values["Melee Attack"])
				UT.check_unit_melee_defence(ingame_values["Melee Defence"], db_values["Melee Defence"])
				UT.check_unit_weapon_strength(ingame_values["Weapon Strength"], db_values["Weapon Strength"])
				UT.check_unit_charge_bonus(ingame_values["Charge Bonus"], db_values["Charge Bonus"])
				print("----------")				
				UT.write_to_output_log("----------")				
	rename_output_log(test_path+"_data_comparison_output")

# Arguments parsed in via the command line.
faction_key = sys.argv[1]
results_file_path = sys.argv[2]

# Script execution begins here
if __name__ == "__main__":
	print("Starting Database Comparison...")
	fetched_unit_data = get_set_faction_unit_data(faction_key)
	write_csv_row(fetched_unit_data)
	check_csv_data(fetched_unit_data, results_file_path)