# meta-name: Annoted biotik
# meta-description: Base template with complete annoted code for scene generation in Biotik
"""=============================================
File: class_encounter.gd
Author: Ska
Version: 0.1
Description:
	Manages all random biomon encounter

Changes: 
	0.1
		- file creation

To-do: 
	-(...)
============================================="""

extends Node2D

class_name ClassEncounter

# Set up signals
signal SignalEncounter

# Set up constants

# Set up variables
export(String, FILE, "*.json") var encounter_file
export(String, FILE) var background_image
var encounter_rate = 10 # En %
var encounter_dictionnary



"""=====
Function load_scene
Author: Ska
	Function called when the scene manager is ready make the scene appears. Loads all relevant Data
	for the scene.

Arguments
	- inherited_parameters: dictionnary of parameters given by the last scene
====="""
func _ready():
	""" connect to signals from children """
	for _i in self.get_children():
		assert(_i.connect("SignalPlayerInside", self, "roll_encounter") == 0, "ERR:class_encounter> '" + self.name + "' in '" + get_parent().name + "' failed to connect to 'SignalPlayerInside' in '" + _i.name + "' !")
	
	""" connect signal to parent """
	assert(connect("SignalEncounter", get_parent(), "generate_encounter")==0, "Encounter '" + self.name + " failed to connect to parent scene '" + get_parent().name + "'")
	
	""" open the encounter file """
	encounter_dictionnary = DataRead.load_encounter_dictionnary(encounter_file)
	print(encounter_dictionnary)
	
	

"""=====
Function roll_encounter
Author: Ska
	Function called when the player enters a tiles with possible encounters.

====="""
func roll_encounter(debug=false):
	var roll = RandomNumberGenerator.new()
	roll.randomize()
	print("=============================")
	""" Check if encounter happens """
	print("Check if encounter happens...")
	var temp = roll.randi_range(0, 100)
	print("Rolled '" + str(temp) + "'")
	if temp < encounter_rate:
		var temp_dict = calculate_encounter()
		if debug:
			return temp_dict
		else:
			emit_signal("SignalEncounter", temp_dict)
	else:
		print("...No encounter happened !")

"""=====
Function roll_encounter
Author: Ska
	Calculs which biomon the player encounters

====="""
func calculate_encounter():
	# Prepare variables
	var rate_total = 0
	var count = 0
	var rate_rng = RandomNumberGenerator.new()
	rate_rng.randomize()
	for key in encounter_dictionnary.keys():
		rate_total += encounter_dictionnary[key]["rate"]
	var rate_result = rate_rng.randi_range(1, rate_total)
	print("Rate result : " + str(rate_result))
	# Calculate which biomon is seen
	for key in encounter_dictionnary.keys():
		print("Rate for key '" + key + "': " + str(encounter_dictionnary[key]["rate"]))
		print("Count : " + str(count))
		if rate_result <= encounter_dictionnary[key]["rate"] + count:
			var calc_lvl = rate_rng.randi_range(encounter_dictionnary[key]["lvl_min"], encounter_dictionnary[key]["lvl_max"])
			return {"id": key, "level": calc_lvl}
		else:
			count += encounter_dictionnary[key]["rate"]
	print("Failed to find an encounter; rates failed")
	return null
