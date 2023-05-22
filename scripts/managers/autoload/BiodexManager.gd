extends Node

enum BiodexStates {NONE = 0, SEEN = 1, GOT = 2}

var biodex_state = {}

# For new games only
func load_biodex_manager():
	pass
	

"""
func release_biomon(unique_key):
	Utils.get_dialogue_manager().submit_dialogue(self, 'biomon_release', 'release_biomon_feedback')
	temp_biomon_key = unique_key

	
func release_biomon_feedback(feedback):
	if feedback == "true":
		Utils.get_dialogue_manager().submit_dialogue(self, 'biomon_releasing', 'release_biomon_feedback')
		remove_biomon(temp_biomon_key)
	elif feedback == "false":
		Utils.get_dialogue_manager().close_dialogue()
	elif feedback == "end":
		temp_biomon_key = null

""" 

func get_biomon_from_party(_slot:int = 1):
	pass


func get_biodex_state(id = null):
	if id == null:
		return biodex_state
	elif not id in biodex_state.keys():
		return BiodexStates.NONE
	else:
		return biodex_state.id


func new_encounter(new_biomon):
	if not new_biomon.species_key in biodex_state.keys():
		biodex_state[new_biomon.species_key] = BiodexStates.SEEN


func new_biomon(new_biomon) -> void:
	biodex_state[new_biomon.species_key] = BiodexStates.GOT


func biomons_seen():
	return biodex_state.size()
	
func biomons_got():
	var count = 0
	for key in biodex_state.keys():
		if biodex_state.key == BiodexStates.GOT:
			count += 1
	return count


func saving_game_data():
	return biodex_state
	

func loading_game_data(game_dictionary):
	biodex_state = game_dictionary
