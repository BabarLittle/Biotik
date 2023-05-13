""" Auto-load file to load and manage all game data"""

extends Node

export var data_directory = "res://data/"
export var biodex_file_name = "biodex.json"
export var type_chart_file_name = "type_chart.json"
export var natures_file_name = "natures.json"

var database = {}
var biodex = "biodex"
var type_chart = "type_chart"
var natures = "natures"

var type_frame = {
	"NORMAL": 0, 
	"DRAGON": 1, 
	"ICE": 2, 
	"GRASS": 3, 
	"BUG": 4,
	"ROCK": 5,
	"WATER": 6,
	"FIGHTING": 7,
	"GROUND": 8,
	"FIRE": 9,
	"STEEL": 10,
	"FLYING": 11,
	"PSYCHIC": 12,
	"ELECTRIC": 13,
	"DARK": 14,
	"GHOST": 15,
	"FAIRY": 16,
	"POISON": 17,
	"WORK": 17,
	"ALCOHOL": 19,
	"NULL": 20
	}

func _ready():
	""" Load biodex """
	# open file and transform the json into a dict
	var biodex_file = File.new()
	assert(biodex_file.file_exists(data_directory+biodex_file_name), "The specified file for biodex '%s%%' does not exist!" % biodex_file_name)
	biodex_file.open(data_directory+biodex_file_name, File.READ)
	var biodex_json = JSON.parse(biodex_file.get_as_text())
	biodex_file.close()
	var biodex_dict = biodex_json.result
	# change the double type to "NULL" if no double type.
	for key in biodex_dict.keys():
		if biodex_dict[key].type1 == "":
			biodex_dict[key].type1 = "NULL"
		if biodex_dict[key].type2 == "":
			biodex_dict[key].type2 = "NULL"
	# add the dictionnary inside the dict_data_base dictionnary
	database[biodex] = biodex_dict
	
	""" Load type chart """
	# open file and transform the json into a dict
	var type_chart_file = File.new()
	assert(type_chart_file.file_exists(data_directory+type_chart_file_name), "The specified file for type_chart '%s%%' does not exist!" % type_chart_file_name)
	type_chart_file.open(data_directory+type_chart_file_name, File.READ)
	var type_chart_json = JSON.parse(type_chart_file.get_as_text())
	type_chart_file.close()
	var type_chart_dict = type_chart_json.result
	# add the dictionnary inside the dict_data_base dictionnary
	database[type_chart] = type_chart_dict
	# add the frame id to the type_chart
	for key in database[type_chart].keys():
		database[type_chart][key].type_frame = type_frame[key]
		
	""" Load moves """
	# wip...
	
	""" Load natures """
	var natures_file = File.new()
	assert(type_chart_file.file_exists(data_directory+natures_file_name), "The specified file for type_chart '%s%%' does not exist!" % type_chart_file_name)
	natures_file.open(data_directory+type_chart_file_name, File.READ)
	var natures_json = JSON.parse(natures_file.get_as_text())
	natures_file.close()
	var natures_dict = natures_json.result
	# add the dictionnary inside the dict_data_base dictionnary
	database[natures] = natures_dict


"""=====
Function next_id()
	-Returns the next available id after "id" in the dictionnary "data" with a jump of "jump"
	NOTE : only work with dictionnary with some keys as number
Arguments
	-id(int): current id
	-forward(bool): the direction in wich we're going to explore the dictionnary
	-jump(int): number of correct id to ignore / also direction of search
	-data(str): name of the dictionnary. Can be checked with DataRead.database.has[data] Can also be any dictionnary
Return :
	-int => the value of the next valid id in the selected data
====="""
func next_id(id=1, jump=1, dict=biodex):
	var data = {}
	
	"""" Check if the data base exists """
	if typeof(dict) == TYPE_DICTIONARY:
		data = dict
	elif database.has(dict):
		data = database[dict]
	else:	
		print("ERR:'DataRead/next_id()'> database '" + dict + "' does not exist ! Returns -1")
		return -1
	
	""" Check if the id exists """
	if !data.has(str(id)):
		print("ERR:'DataRead/next_id()'> id '" + str(id) + "' does not exist in '"+ dict + "' ! Same id returned.")
		return id
	
	""" Check if jump = 0, return the same id """
	if jump == 0:
		print("WAR:'DataRead/next_id()'> jump = 0. Same id returned.")
		print("_with id: " + str(id))
		return id
	
	
	""" main code of the function """
	var id_pos = data.keys().find(str(id)) # take the position of the current id in the key list
	var new_id = -1 # declare the new id
	
	# As long as the id isnt good, we keep going
	while !data.has(str(new_id)):
		if jump == 0:
			new_id = int(data.keys()[id_pos])
		else:
			id_pos += abs(jump)/jump
			if id_pos >= data.keys().size():
				id_pos = 0
			elif id_pos < 0:
				id_pos = data.keys().size()-1
			if data.keys()[id_pos].count(".") == 0:
				jump -= abs(jump)/jump
	return new_id


"""=====
get_biomon_numbers()
	-Count the number of biomon 
Arguments
	-final_evolution: if true, count only the 
Returns
	-A list of keys (list of strings)
"""
func get_biomon_numbers(forms: bool=false, final_evolution: bool=false):
	var biomon_number = 0
	
	if final_evolution:
		for key in database.biodex.keys():
			if database.biodex[key].evo_to == "" and not "." in key:
				biomon_number += 1
	elif forms:
		return biodex.size()
	else:
		for key in database.biodex.keys():
			if not "." in key: # skip if "." ("." in a key = form of another key)
				biomon_number += 1
	return biomon_number


"""=====
get_biomon_forms()
	-Returns a list of the keys of all the different forms of a biomon 
Arguments
	-id: the key of the biomon being investigated. Can be both string or int
Returns
	-A list of keys (list of strings)
"""
func get_biomon_forms(biomon_id=0):
	var biomon_key = ""
	
	""" Check the typing of id """
	if typeof(biomon_id) == TYPE_STRING:
		biomon_key = biomon_id
	elif typeof(biomon_id) == TYPE_INT:
		biomon_key = str(biomon_id)
	else:
		print("ERR:'DataRead/get_biomon_forms'> Argument 'biomon_id' has the wrong typing. Submit an INT or a STRING.")
		return []
	
	""" Check if the id exists """
	if !biodex.has(biomon_key):
		print("ERR:'DataRead/next_id()'> Key '" + biomon_key + "' does not exist in 'biodex' ! Same id returned.")
		return [biomon_id]
		
	""" main code of the function """
	var list_keys_forms = [biomon_key] # Declare the list to return with the first called biomon in it.
	
	for key in biodex.keys():
			if "." in key and biomon_key in key: # skip if "." ("." in a key = form of another key)
				list_keys_forms.append(key)
	
	return list_keys_forms


"""=====
get_all_biomons_of_types()
	-Returns a list of the keys of all the biomon of the specified type
Arguments
	-type_list: A list of the types we're looking for. Also can be a string. 
	-type_exclusive: if true, look only for biomon strictly of the specified types (ex: no dual type
	 water/fire if looking for "water" with "true".
Returns
	-A list of keys (list of strings)
"""
func get_all_biomons_of_types(types = "", type_exclusive: bool= false):	
	var type_list = []
	
	""" Check the typing of id """
	if typeof(types) == TYPE_STRING:
		type_list.append(types)
	elif typeof(types) == TYPE_ARRAY:
		if types == []:
			print("ERR:'DataRead/get_all_biomons_of_types'> Argument 'types' has the wrong typing. Submit a string or an array of strings.")
			return []
		else:
			for i in range(0, type_list.size()):
				if typeof(type_list[i]) != TYPE_STRING:
					print("ERR:'DataRead/get_all_biomons_of_types'> Argument 'types' has the wrong typing. Submit a string or an array of strings.")
					return []
	
	""" Check if the types exist """
	for i in type_list.size():
		if !database[type_chart].has(type_list[i]):
			print("ERR:'DataRead/get_all_biomons_of_types'> Type '" + type_list[i] +  "' Does not exists !")
			return []
	
	""" main code of the function """
	var biomons_of_type = []
	
	if !type_exclusive:
		for key in database[biodex].keys():
			if type_list.has(database[biodex].type1) or type_list.has(database[biodex].type2):
				biomons_of_type.append(key)
	else:
		type_list.append("NULL")
		for key in database[biodex].keys():
			if type_list.has(database[biodex].type1) and type_list.has(database[biodex].type2):
				biomons_of_type.append(key)

"""=====
Function get_keys_int()
	-Returns a list of the keys in integer
Arguments
	-type_list: A list of the types we're looking for. Also can be a string. 
	-type_exclusive: if true, look only for biomon strictly of the specified types (ex: no dual type
	 water/fire if looking for "water" with "true".
Returns
	-A list of keys (list of strings)
"""
func keys_int(dataset):
	var list = []
	for key in database[dataset].keys():
		list.append(int(key))
	return list

"""=====
Function load_encouter()
	-Load specified encounter file and returns it as a dictionnary
Arguments
	-encouter_file: json file holding the encounter for the calling ClassEncounter node
Returns
	-A dictionnary of dictionnary with biomon encounters rate inside
"""
func load_encounter_dictionnary(encounter_file: String):
	# open file and transform the json into a dict
	var temp_file = File.new()
	assert(temp_file.file_exists(encounter_file), "The specified file for biodex '%s%%' does not exist!" % biodex_file_name)
	temp_file.open(encounter_file, File.READ)
	var temp_json = JSON.parse(temp_file.get_as_text())
	temp_file.close()
	
	return temp_json.result

"""=====
Function get_base_stats_dictionnary()
	- Returns a dictionnary with the base_stats of the specified biomon.
Arguments
	-id: json file holding the encounter for the calling ClassEncounter node
Returns
	-A dictionnary base stats
"""
func get_base_stats_dictionary(id):
	var base_stats_dictionary = {
	"hp": 0,
	"att": 0,
	"def": 0,
	"vit": 0,
	"spd": 0,
	"spa": 0
	}
	
	""" check variables """
	if typeof(id) != TYPE_STRING:
		id = str(id)
	
	""" Check if id exists """
	if !database.biodex.has(id):
		print("ERR:DataRead.get_base_stats_dictionnary> Key '" + id + "' does not exist in the biodex dictionnary !")
		return base_stats_dictionary
	
	print(database.biodex[id])
	""" main body """
	for key in base_stats_dictionary.keys():
		if typeof(database.biodex[id][key]) == 3:
			base_stats_dictionary[key] = int(database.biodex[id][key])
	
	print("Base stats for id '" + id + "' : " + str(base_stats_dictionary))
	return base_stats_dictionary

func get_biomon_known_state(_id):
	return 1

func get_highest_biomon_id():
	var highest_id = 0
	for key in database.biodex.keys():
		if not "." in key:
			if int(key) > highest_id:
				highest_id = int(key)
	return highest_id

func get_biomon_id_distance(biomon_id1, biomon_id2):
	var iterator = 0
	var position1 = 0
	var position2 = 0
	for key in database.biodex.keys():
		if key == str(biomon_id1):
			position1 = iterator
		if key == str(biomon_id2):
			position2 = iterator
		iterator += 1
	return position2 - position1

func get_nature_dictionnary(nature):
	return database.natures[nature]
	
func get_random_nature():
	var random_number = RandomNumberGenerator.new()
	var nature = ""
	var iterator = 0
	
	random_number.randomize()
	iterator = random_number.randi_range(0,database.nature.size())
	
	for key in database.natures.keys():
		if iterator == 0:
			nature = key
			break
		iterator -= 1
	
	return nature
	
func load_learnset(species):
	var learnset_code = DataRead.database.biodex["learn-set"]
	var bin_move = 10
	var bin_nb = 7
	var value = 0
	var value2 = 0
	var temp = ''
	
	assert(len(learnset_code) != 0, "No learnset found  for " + species + " !")
	
	for i in len(learnset_code):
		if learnset_code[i] == '/':
			# Unpatch move binary id into a temp string
			temp = ''
			
			for j in range(bin_move):
				temp = temp + learnset_code[i+j+1];
		
			# update iterator i so we don't have to do unecessary loops
			i = i + bin_move

			# convert binary text to decimal integer
			value = bin2dec(temp);


		# Unpatch learning method
		# CT, Egg, Tutor
		elif learnset_code[i] in ['c', 'e', 't']:
			database.biodex.learnset.learnset_code[i].append(value)
		elif learnset_code[i] == 'l':
			# reset temp
			temp = ''
			for j in range(bin_nb):
				temp = temp + learnset_code[i+j+1]
			# update iterator
				i = i + bin_nb;
			# convert binary text to decimal integer
			value2 = bin2dec(temp);
			
			database.biodex.learnset.learnset_code[i].value2 = value

func bin2dec(value):
	var dec = 0;
	for i in range(len(value)):
		if value[i] == '1':
			dec = dec + pow(2, len(value)-(i+1))
  return dec
