extends Node2D

const PARTY_MAX = 6

var boxes = ClassBoxes.new()


func _ready():
	pass

func new_biomon():
	pass
	

func release_biomon():
	pass
	

func get_box(id = null):
	if id == null:
		return boxes.boxes
	else:
		return boxes.boxes[id]

func party_array_to_node(array_party) -> void:
	for i in range(array_party.size()):
		if array_party[i] != null:
			array_party[i].instance()
			


func party_node_to_array() -> Array:
	var party = []
	
	for child in get_children():
		party.append(child.get_biomon_object())
		
	while party.size() < PARTY_MAX:
		party.append(null)
	
	return party


func loading_game_data(game_dictionary) -> void:
	party_array_to_node(game_dictionary.load_party)
	boxes = game_dictionary.boxes


func saving_game_data() -> Dictionary:
	var save_dictionary = {}
	
	save_dictionary.party = party_node_to_array()
	save_dictionary.boxes = boxes
	
	return save_dictionary
