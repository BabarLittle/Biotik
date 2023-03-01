""" Auto-load file to load and manage all  game data"""

extends Node

var database = {}
var biodex

func _ready():
	""" Load biodex """
	# open file and transform the json into a dict
	var biodex_file = File.new()
	biodex_file.open("res://data/biodex.json", File.READ)
	var biodex_json = JSON.parse(biodex_file.get_as_text())
	biodex_file.close()
	biodex = biodex_json.result
	# add the dictionnary inside the dict_data_base dictionnary
	database["biodex"] = biodex
	
	""" Load moves """
	# wip...


"""=====
Function next_(id)
	-Returns the next available id after "id" in the dictionnary "data" with a jump of "jump"
Arguments
	-id(int): current id
	-forward(bool): the direction in wich we're going to explore the dictionnary
	-jump(int): number of correct id to ignore / also direction of search
	-data(str): name of the dictionnary. Can be checked with DataRead.database.has[data] Can also be any dictionnary
Return :
	-int => the value of the next valid id in the selected data
====="""
func next_id(id=1, jump=1, dict="biodex"):
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
	
	
