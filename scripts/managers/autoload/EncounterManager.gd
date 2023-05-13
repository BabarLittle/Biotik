extends Node

enum EncounterZone {NONE=0, GROUND=1, WATER=2, TREE=3, FISHING=4}

const ENCOUNTER_PATH = "res://data/encounters/"

var current_encounter_dictionary = {}
var no_encounter = false

func load_encounter_dictionary(file_name = "no_file_specified"):
	var temp_file = File.new()
	var file_path
	
	if temp_file.file_exists(file_name):
		file_path = file_name
	elif temp_file.file_exists(ENCOUNTER_PATH + file_name + ".json"):
		file_path = ENCOUNTER_PATH + file_name + ".json"
	else:
		no_encounter = true
		print("No file found with " +  file_name)
		return
	
	print("EncounterManager // Loading encounter file at " + file_path)
	temp_file.open(file_path, File.READ)
	var encounter_json = JSON.parse(temp_file.get_as_text())
	temp_file.close()
	
	no_encounter = false
	
	current_encounter_dictionary = encounter_json.result
	
func calculate_encounter(encounter_zone):
	if no_encounter:
		return
	
	encounter_zone = str(encounter_zone)
	if not encounter_zone in current_encounter_dictionary.keys():
		print(encounter_zone)
		return
	
	var rand_int = RandomNumberGenerator.new()
	rand_int.randomize()
	var result = rand_int.randi_range(0,100)
	
	print("=== Check if encounter happens... ===")
	print("Rolled '" + str(result) + "/" + str(current_encounter_dictionary[encounter_zone].global_rate))
	if result < current_encounter_dictionary[encounter_zone].global_rate:
		return generate_encounter(current_encounter_dictionary[encounter_zone].biomons)
	else:
		print(" > No encounter happened")
		return null
		
func generate_encounter(possible_biomons):
	var rate_total = 0
	var count = 0
	var rate_rng = RandomNumberGenerator.new()
	var rate = Utils.get_game_timer().get_period_string() + "_rate"
	rate_rng.randomize()
	
	for key in possible_biomons.keys():
		rate_total += possible_biomons[key][rate]
	var rate_result = rate_rng.randi_range(1, rate_total)
	print("Rate result : " + str(rate_result))
	# Calculate which biomon is seen
	for key in current_encounter_dictionary.keys():
		print("Rate for key '" + key + "': " + str(possible_biomons[key][rate]))
		print("Count : " + str(count))
		if rate_result <= possible_biomons[key][rate] + count:
			var calc_lvl = rate_rng.randi_range(possible_biomons[key]["lvl_min"], possible_biomons[key]["lvl_max"])
			return {"biomon_key": key, "level": calc_lvl}
		else:
			count += possible_biomons[key][rate]
	
	print("Failed to find an encounter; rates failed")

func free_dictionnary():
	current_encounter_dictionary = null
	no_encounter = true
