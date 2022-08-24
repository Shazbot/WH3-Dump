import os
import xml.etree.ElementTree as ET
from pathlib import Path

def get_wh3_db_location():
	'''Grabs the local raw_data/db folder location and returns the path as a string'''

	file_path = str(Path(os.path.dirname(__file__)).parents[9])
	for root, dirs, _ in os.walk(file_path):
		if "branches" in dirs:
			path_construct = os.path.join(root, "branches")
		for root, dirs, _ in os.walk(path_construct):
			if "warhammer3" in dirs:
				path_construct = os.path.join(path_construct, "warhammer3")                 
			for root, dirs, _ in os.walk(path_construct):
				if dirs.__contains__("warhammer"):
					path_construct = os.path.join(root, "warhammer", "raw_data", "db")
					return path_construct

root_path = get_wh3_db_location()

def get_main_units_root():
	'''Fetches, reads and returns the main_units.xml from the raw_data/db location'''
	main_units_root = ET.parse(root_path+"\\main_units.xml")
	return main_units_root.getroot()

def get_land_units_root():
	'''Fetches, reads and returns the land_units.xml from the raw_data/db location'''
	land_units_root = ET.parse(root_path+"\\land_units.xml")
	return land_units_root.getroot()

def get_battle_entities_root():
	'''Fetches, reads and returns the battle_entities.xml from the raw_data/db location'''
	battle_entities_root = ET.parse(root_path+"\\battle_entities.xml")
	return battle_entities_root.getroot()

def get_unit_special_abilities_root():
	'''Fetches, reads and returns the unit_special_abilities.xml from the raw_data/db location'''
	unit_special_abilities_tree = ET.parse(root_path+"\\unit_special_abilities.xml")
	return unit_special_abilities_tree.getroot()

def get_unit_abilities_root():
	'''Fetches, reads and returns the unit_special_abilities.xml from the raw_data/db location'''
	unit_abilities_tree = ET.parse(root_path+"\\unit_abilities.xml")
	return unit_abilities_tree.getroot()

def get_land_unit_abilities_root():
	'''Fetches, reads and returns the land_units_to_unit_abilites_junctions.xml from the raw_data/db location'''
	land_unit_abilities_tree = ET.parse(root_path+"\\land_units_to_unit_abilites_junctions.xml")
	return land_unit_abilities_tree.getroot()

def get_unit_armour_types_root():
	'''Fetches, reads and returns the unit_armour_types.xml from the raw_data/db location'''
	unit_armour_types_tree = ET.parse(root_path+"\\unit_armour_types.xml")
	return unit_armour_types_tree.getroot()

def get_melee_weapons_root():
	'''Fetches, reads and returns the melee_weapons.xml from the raw_data/db location'''
	melee_weapons_tree = ET.parse(root_path+"\\melee_weapons.xml")
	return melee_weapons_tree.getroot()

def get_special_ability_to_special_ability_phase_junctions_root():
	'''Fetches, reads and returns the special_ability_to_special_ability_phase_junctions.xml from the raw_data/db location'''
	special_ability_to_special_ability_junctions_tree = ET.parse(root_path+"\\special_ability_to_special_ability_phase_junctions.xml")
	return special_ability_to_special_ability_junctions_tree.getroot()

def get_regions_root():
	'''Fetches, reads and returns the regions.xml from the raw_data/db location'''
	regions_tree = ET.parse(root_path+"\\regions.xml")
	return regions_tree.getroot()

def get_factions_root():
	'''Fetches, reads and returns the factions.xml from the raw_data/db location'''
	factions_tree = ET.parse(root_path+"\\factions.xml")
	return factions_tree.getroot()

def get_technologies_root():
	'''Fetches, reads and returns the technologies.xml from the raw_data/db location'''
	technologies_tree = ET.parse(root_path+"\\technologies.xml")
	return technologies_tree.getroot()

def get_technology_nodes_root():
	'''Fetches, reads and returns the technology_nodes.xml from the raw_data/db location'''
	technology_nodes = ET.parse(root_path+"\\technology_nodes.xml")
	return technology_nodes.getroot()

def get_technology_node_sets_root():
	'''Fetches, reads and returns the technology_node_sets.xml from the raw_data/db location'''
	technology_node_sets_tree = ET.parse(root_path+"\\technology_node_sets.xml")
	return technology_node_sets_tree.getroot()

def get_technology_effects_junctions_root():
	'''Fetches, reads and returns the technology_effects_junction.xml from the raw_data/db location'''
	technology_effects_junctions_tree = ET.parse(root_path+"\\technology_effects_junction.xml")
	return technology_effects_junctions_tree.getroot()

def get_missions_root():
	'''Fetches, reads and returns the missions.xml from the raw_data/db location'''
	missions_tree = ET.parse(root_path+"\\missions.xml")
	return missions_tree.getroot()

def get_cdir_events_mission_option_junctions_root():
	'''Fetches, reads and returns the cdir_events_mission_option_junctions.xml from the raw_data/db location'''
	cdir_events_mission_option_junctions_tree = ET.parse(root_path+"\\cdir_events_mission_option_junctions.xml")
	return cdir_events_mission_option_junctions_tree.getroot()

def get_dilemmas_root():
	'''Fetches, reads and returns the dilemmas.xml from the raw_data/db location'''
	dilemmas_tree = ET.parse(root_path+"\\dilemmas.xml")
	return dilemmas_tree.getroot()

def get_incidents_root():
	'''Fetches, reads and returns the incidents.xml from the raw_data/db location'''
	incident_tree = ET.parse(root_path+"\\incidents.xml")
	return incident_tree.getroot()

def get_start_pos_starting_general_options_root():
	'''Fetches, reads and returns the start_pos_starting_general_options.xml from the raw_data/db location'''
	start_pos_starting_general_options_tree = ET.parse(root_path+"\\start_pos_starting_general_options.xml")
	return start_pos_starting_general_options_tree.getroot()

def get_frontend_faction_leaders_root():
	'''Fetches, reads and returns the frontend_faction_leaders.xml from the raw_data/db location'''
	frontend_faction_leaders_tree = ET.parse(root_path+"\\frontend_faction_leaders.xml")
	return frontend_faction_leaders_tree.getroot()

def get_start_pos_land_units_root():
	'''Fetches, reads and returns the start_pos_land_units.xml from the raw_data/db location'''
	start_pos_land_units_tree = ET.parse(root_path+"\\start_pos_land_units.xml")
	return start_pos_land_units_tree.getroot()