import db_roots as wh3_xml_roots
import os
from pathlib import Path
from colorama import init, Fore

init(autoreset=True)

def write_to_output_log(str):
	output_log_folder_path = Path(os.path.expanduser(r'~\AppData\Roaming\CA_Autotest\WH3\battle_verification'))
	output_log_file_name = "output_log.txt"
	output_log_folder_path = os.path.join(output_log_folder_path, output_log_file_name)
	with open(output_log_folder_path, "a") as f:
		f.write(str)
		f.write("\n")
		f.close()

def get_entity_percentage(unit_scale):
	if unit_scale == "0.5":
		return 50
	elif unit_scale == "0.25":
		return 25
	else:
		return 100

def check_unit_name(unit_name_game, unit_name_db):
	if unit_name_game != unit_name_db:
		print("[Test - Unit Name] "+ Fore.RED +"Failed")
		write_to_output_log("[Test - Unit Name] - Failed")
		return False
	else:
		print("[Test - Unit Name] "+ Fore.GREEN +"Passed")
		write_to_output_log("[Test - Unit Name] - Passed")
		return True

def check_unit_class(unit_class_game, unit_class_db):
	if unit_class_game != unit_class_db:
		print("[Test - Unit Class] "+ Fore.RED +"Failed")
		write_to_output_log("[Test - Unit Class] - Failed")
		return False
	else:
		print("[Test - Unit Class] "+ Fore.GREEN +"Passed")
		write_to_output_log("[Test - Unit Class] - Passed")
		return True

def check_unit_HP(unit_HP_game, unit_HP_db, entity_count, unit_scale):
	if int(entity_count) == 1:
		if int(unit_HP_game) == int(get_entity_percentage(unit_scale) * int(unit_HP_db) / 100):
			print("[Test - Unit HP] "+ Fore.GREEN +"Passed")
			write_to_output_log("[Test - Unit HP] - Passed")
			return True
		else:
			print("[Test - Unit HP] "+ Fore.RED +"Failed")
			write_to_output_log("[Test - Unit HP] - Failed")
			return False
	else:
		if int(unit_HP_game) == int(entity_count) * int(unit_HP_db):
			print("[Test - Unit HP] "+ Fore.GREEN +"Passed")
			write_to_output_log("[Test - Unit HP] - Passed")
			return True
		else:
			print("[Test - Unit HP] "+ Fore.RED +"Failed")
			write_to_output_log("[Test - Unit HP] - Failed")
			return False

def get_armour_value(armour_key):
	unit_armour_types_root = wh3_xml_roots.get_unit_armour_types_root()
	for unit in unit_armour_types_root.iter("unit_armour_types"):
		if armour_key == unit.get("record_key"):
			return int(unit.find("armour_value").text)

def check_unit_armour(unit_armour_game, unit_armour_db):
	if int(unit_armour_game) != int(unit_armour_db):
		print("[Test - Unit Armour] "+ Fore.RED +"Failed")
		write_to_output_log("[Test - Unit Armour] - Failed")
		return False
	else:
		print("[Test - Unit Armour] "+ Fore.GREEN +"Passed")
		write_to_output_log("[Test - Unit Armour] - Passed")
		return True
		
def check_unit_leadership(unit_leadership, unit_leadership_db):
	if int(unit_leadership) != int(unit_leadership_db):
		print("[Test - Unit Leadership] "+ Fore.RED +"Failed")
		write_to_output_log("[Test - Unit Leadership] - Failed")
		return False
	else:
		print("[Test - Unit Leadership] "+ Fore.GREEN +"Passed")
		write_to_output_log("[Test - Unit Leadership] - Passed")
		return True

def check_unit_speed(unit_speed, unit_speed_db):
	if int(unit_speed) != int(unit_speed_db):
		print("[Test - Unit Speed] "+ Fore.RED +"Failed")
		write_to_output_log("[Test - Unit Speed] - Failed")
		return False
	else:
		print("[Test - Unit Speed] "+ Fore.GREEN +"Passed")
		write_to_output_log("[Test - Unit Speed] - Passed")
		return True

def check_unit_melee_attack(unit_melee_attack_game, unit_melee_attack_db):
	if int(unit_melee_attack_game) != int(unit_melee_attack_db):
		print("[Test - Unit Melee Attack] "+ Fore.RED +"Failed")
		write_to_output_log("[Test - Unit Melee Attack] - Failed")
		return False
	else:
		print("[Test - Unit Melee Attack] "+ Fore.GREEN +"Passed")
		write_to_output_log("[Test - Unit Melee Attack] - Passed")
		return True

def check_unit_melee_defence(unit_melee_defence_game, unit_melee_defence_db):
	if int(unit_melee_defence_game) != int(unit_melee_defence_db):
		print("[Test - Unit Melee Defence] "+ Fore.RED +"Failed")
		write_to_output_log("[Test - Unit Melee Defence] - Failed")
		return False
	else:
		print("[Test - Unit Melee Defence] "+ Fore.GREEN +"Passed")
		write_to_output_log("[Test - Unit Melee Defence] - Passed")
		return True

def get_weapon_strength_value(weapon_key):
	melee_weapons_root = wh3_xml_roots.get_melee_weapons_root()
	for unit in melee_weapons_root.iter("melee_weapons"):
		if weapon_key == unit.get("record_key"):
			damage = int(unit.find("damage").text) + int(unit.find("ap_damage").text)
			return damage

def check_unit_weapon_strength(unit_weapon_strength_game, unit_weapon_strength_db):
	if int(unit_weapon_strength_game) != int(unit_weapon_strength_db):
		print("[Test - Unit Weapon Strength] "+ Fore.RED +"Failed")
		write_to_output_log("[Test - Unit Weapon Strength] - Failed")
		return False
	else:
		print("[Test - Unit Weapon Strength] "+ Fore.GREEN +"Passed")
		write_to_output_log("[Test - Unit Weapon Strength] - Passed")
		return True

def check_unit_charge_bonus(unit_charge_bonus_game, unit_charge_bonus_db):
	if int(unit_charge_bonus_game) != int(unit_charge_bonus_db):
		print("[Test - Unit Charge Bonus] "+ Fore.RED +"Failed")
		write_to_output_log("[Test - Unit Charge Bonus] - Failed")
		return False
	else:
		print("[Test - Unit Charge Bonus] "+ Fore.GREEN +"Passed")
		write_to_output_log("[Test - Unit Charge Bonus] - Passed")
		return True

def check_ability_data(ingame_data, db_data):
	for db_ability_key, db_ability_data in db_data.items():
		for ability_key, ability_data in ingame_data.items():
			if ability_data["Stats"]["name"] == db_ability_data["name"]:
				print("Running Database comparison on Ability - "+db_ability_data["name"])
				check_ability_cast_range(ability_data["Stats"]["castRange"], db_ability_data["castRange"])
				check_ability_affects_self(ability_data["Stats"]["affectsSelf"], db_ability_data["affectsSelf"])
				check_ability_affects_enemy(ability_data["Stats"]["affectsEnemy"], db_ability_data["affectsEnemy"])
				check_ability_affects_ally(ability_data["Stats"]["affectsAlly"], db_ability_data["affectsAlly"])
				check_ability_wind_up_time(ability_data["Stats"]["windUpTime"], db_ability_data["windUpTime"])
				check_ability_recharge_time(ability_data["Stats"]["rechargeTime"], db_ability_data["rechargeTime"])
				check_ability_number_of_uses(ability_data["Stats"]["numberOfUses"], db_ability_data["numberOfUses"])
				check_ability_duration(ability_data["Stats"]["duration"], db_ability_data["duration"])
				check_ability_mana_used(ability_data["Stats"]["manaUsed"], db_ability_data["manaUsed"])
				check_ability_minimum_range(ability_data["Stats"]["minimumRange"], db_ability_data["minimumRange"])
				check_ability_is_passive(ability_data["Stats"]["isPassive"], db_ability_data["isPassive"])
				print("----------")

def check_ability_cast_range(ingame_cast_range, db_cast_range):
	if int(ingame_cast_range) != int(db_cast_range):
		print("	[Test - Ability Cast Range] "+ Fore.RED +"Failed")
		return False
	else:
		print("	[Test - Ability Cast Range] "+ Fore.GREEN +"Passed")
		return True

def check_ability_affects_self(ingame_affects_self, db_affects_self):
	if bool(ingame_affects_self) != bool(db_affects_self):
		print("	[Test - Ability Affects Self] "+ Fore.RED +"Failed")
		return False
	else:
		print("	[Test - Ability Affects Self] "+ Fore.GREEN +"Passed")
		return True

def check_ability_affects_enemy(ingame_affects_enemy, db_affects_enemy):
	if bool(ingame_affects_enemy) != bool(db_affects_enemy):
		print("	[Test - Ability Affects Enemy] "+ Fore.RED +"Failed")
		return False
	else:
		print("	[Test - Ability Affects Enemy] "+ Fore.GREEN +"Passed")
		return True

def check_ability_affects_ally(ingame_affects_ally, db_affects_ally):
	if bool(ingame_affects_ally) != bool(db_affects_ally):
		print("	[Test - Ability Affects Ally] "+ Fore.RED +"Failed")
		return False
	else:
		print("	[Test - Ability Affects Ally] "+ Fore.GREEN +"Passed")
		return True

def check_ability_wind_up_time(ingame_wind_up_time, db_wind_up_time):
	if int(ingame_wind_up_time) != int(db_wind_up_time):
		print("	[Test - Ability Wind Up Time] "+ Fore.RED +"Failed")
		return False
	else:
		print("	[Test - Ability Wind Up Time] "+ Fore.GREEN +"Passed")
		return True

def check_ability_recharge_time(ingame_recharge_time, db_recharge_time):
	if int(ingame_recharge_time) != int(db_recharge_time):
		print("	[Test - Ability Recharge Time] "+ Fore.RED +"Failed")
		return False
	else:
		print("	[Test - Ability Recharge Time] "+ Fore.GREEN +"Passed")
		return True

def check_ability_number_of_uses(ingame_number_of_uses, db_number_of_uses):
	if int(ingame_number_of_uses) != int(db_number_of_uses):
		print("	[Test - Ability Number of Uses] "+ Fore.RED +"Failed")
		return False
	else:
		print("	[Test - Ability Number of Uses] "+ Fore.GREEN +"Passed")
		return True

def check_ability_duration(ingame_duration, db_duration):
	if int(ingame_duration) != int(db_duration):
		print("	[Test - Ability Duration] "+ Fore.RED +"Failed")
		return False
	else:
		print("	[Test - Ability Duration] "+ Fore.GREEN +"Passed")
		return True

def check_ability_mana_used(ingame_mana_used, db_mana_used):
	if int(ingame_mana_used) != int(db_mana_used):
		print("	[Test - Ability Mana Used] "+ Fore.RED +"Failed")
		return False
	else:
		print("	[Test - Ability Mana Used] "+ Fore.GREEN +"Passed")
		return True

def check_ability_minimum_range(ingame_minimum_range, db_minimum_range):
	if int(ingame_minimum_range) != int(db_minimum_range):
		print("	[Test - Ability Minimum Range] "+ Fore.RED +"Failed")
		return False
	else:
		print("	[Test - Ability Minimum Range] "+ Fore.GREEN +"Passed")
		return True

def check_ability_is_passive(ingame_is_passive, db_is_passive):
	if bool(ingame_is_passive) != bool(db_is_passive):
		print("	[Test - Ability Is Passive] "+ Fore.RED +"Failed")
		return False
	else:
		print("	[Test - Ability Is Passive] "+ Fore.GREEN +"Passed")
		return True