extends Node2D

var biodex_state = {}
var boxes = ClassBoxes

func _ready():
	pass
	
func load_game(game_dictionary):
	pass
	
func save_game():
	var save_dictionary = {}
	var party = []
	
	for child in get_children():
		party.append(child.get_biomon_object())
	
	save_dictionary.party = party
	save_dictionary.boxes = boxes
	save_dictionary.biodex_state = biodex_state
	
	return save_dictionary
