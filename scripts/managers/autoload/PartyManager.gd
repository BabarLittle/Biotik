extends Node

const PARTY_LIMIT = 6
const BOX_LIMIT = 20

var biomons_dictionary:Dictionary = {}
var container_array:Array = []
var biomons_collection_status:Dictionary = {}
var current_box = 1

var temp_biomon_key = ''
var temp_container_key = ''

# For new games only
func load_party_manager():
	load_biomons_collection_status()
	load_container_array()
	current_box = 1

func load_biomons_collection_status():
	for key in DataRead.database.biodex.keys():
		biomons_collection_status.key.seen = false
		biomons_collection_status.key.captured = false
	
func load_container_array():
	for i in range(0, 6):
		container_array.append({"name": str(i), "biomons_keys": []})
		for j in range(BOX_LIMIT):
			container_array[j].biomons_keys.append(null)
####
func find_next_space():
	pass

func add_new_biomon(new_biomon, position):
	container_array[position[0]]

func switch_biomons():
	pass

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

func remove_biomon(key):
	container_array[biomons_dictionary.key.position[0]].biomons_keys.pop_at(biomons_dictionary.key.position[1])
	biomons_dictionary.erase(key)

func get_biomon_from_party(_slot:int = 1):
	pass
	
func get_nb_biomons_seen():
	var count = 0
	for key in biomons_collection_status.keys():
		if biomons_collection_status[key].seen:
			count += 1
	return count
	
func get_nb_biomons_captured():
	var count = 0
	for key in biomons_collection_status.keys():
		if biomons_collection_status[key].captured:
			count += 1
	return count

func check_biomon_id_state(biomon_id):
	if biomons_collection_status[str(biomon_id)].captured:
		return 2
	elif biomons_collection_status[str(biomon_id)].seen:
		return 1
	else:
		return 0

func saving_game_data():
	var saved_dictionary = {
		"biomons_collection_status": biomons_collection_status,
		"biomons_dictionary": biomons_dictionary,
		"container_array": container_array,
		"current_box": current_box
	}
	return saved_dictionary
	
func loading_game_data(game_dictionary):
	biomons_collection_status = game_dictionary.biomons_collection_status
	biomons_dictionary = game_dictionary.biomons_dictionary
	container_array = game_dictionary.container_array
	current_box = game_dictionary.current_box
