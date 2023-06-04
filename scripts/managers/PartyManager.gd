extends Node2D

const PARTY_MAX = 6

var boxes = ClassBoxes.new()
var party_size = 0
var party = []

export(bool) var rewrite_party = false

func new_biomon(biomon, rename:bool = false):
	var new_biomon
	
	if typeof(biomon) == TYPE_DICTIONARY:
		new_biomon = ClassBiomon.new(biomon)
	elif typeof(biomon) == TYPE_INT:
		new_biomon = ClassBiomon.new({"species_id": str(biomon)})
	elif typeof(biomon) == TYPE_STRING:
		new_biomon = ClassBiomon.new({"species_id": biomon})
	else:
		new_biomon = biomon
	
	if party_size < PARTY_MAX:
		party[party_size] = new_biomon
		party_size += 1
	else:
		boxes.add_biomon(new_biomon)


func release_biomon():
	pass
	

func get_box(id = null):
	if id == null:
		return boxes.boxes
	else:
		return boxes.boxes[id]
		

func party_node_to_array() -> void:
	for child in get_children():
		party.append(child.get_biomon_dictionary())
	
	while party.size() < PARTY_MAX:
		party.append(null)
		
	for i in range(PARTY_MAX):
		if party[i] != null:
			party[i] = ClassBiomon.new(party[i])
	
	update_party_size()


func update_party_size():
	var size = PARTY_MAX
	
	for item in party:
		if item == null:
			size -= 1
	
	return size


func loading_game_data(game_dictionary) -> void:
	#party_array_to_node(game_dictionary.load_party)
	if "party" in game_dictionary.keys() and !rewrite_party:
		party = game_dictionary.party

	boxes = game_dictionary.boxes


func saving_game_data() -> Dictionary:
	var save_dictionary = {}
	
	save_dictionary.party = party
	save_dictionary.boxes = boxes
	
	return save_dictionary
