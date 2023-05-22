extends Node2D

var biodex_state = {}
var boxes = ClassBoxes



func _ready():
	pass


func party_array_to_node(array_party) -> void:
	for i in range(array_party.size()):
		array_party[i].instance()


func party_node_to_array() -> Array:
	var party = []
	
	for child in get_children():
		party.append(child.get_biomon_object())
	
	return party


func load_game(game_dictionary) -> void:
	biodex_state = game_dictionary.biodex_state
	party_array_to_node(game_dictionary.load_party)


func save_game() -> Dictionary:
	var save_dictionary = {}
	
	save_dictionary.party = party_node_to_array()
	save_dictionary.boxes = boxes
	save_dictionary.biodex_state = biodex_state
	
	return save_dictionary
