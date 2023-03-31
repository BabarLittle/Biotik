extends Node

const PARTY_LIMIT = 6
const BOX_LIMIT = 20

var biomons_dictionary:Dictionary = {}
var container_dictionary:Dictionary = {}
var biomons_collection_status:Dictionary = {}

func load_party_manager():
	load_biomons_dictionary()
	load_container_dictionary()

func load_biomons_dictionary():
	pass
	
func load_container_dictionary():
	pass

func save_biomons_dictionary():
	pass

func update_biomons_dictionary():
	pass

func add_biomon_to_location():
	pass

func switch_biomons():
	pass

func release_biomon():
	pass

func get_biomon_from_party(slot:int = 1):
	pass
	
func get_nb_biomons_seen():
	var count = 0
	for key in biomons_collection_status.keys():
		count += biomons_collection_status[key].seen
	return count
	
func get_nb_biomons_captured():
	var count = 0
	for key in biomons_collection_status.keys():
		count += biomons_collection_status[key].captured
	return count

func check_biomon_id_state(biomon_id):
	if biomons_collection_status[str(biomon_id)].captured > 0:
		return 2
	elif biomons_collection_status[str(biomon_id)].seen > 0:
		return 1
	else:
		return 0

func saving_game_data():
	var saved_dictionary = {
		"biomons_collection_status": biomons_collection_status,
		"biomons_dictionary": biomons_dictionary,
		"container_dictionary": container_dictionary
	}
	return saved_dictionary
	
func loading_game_data(game_dictionnary):
	biomons_collection_status = game_dictionnary.biomons_collection_status
	biomons_dictionary = game_dictionnary.biomons_dictionary
	container_dictionary = game_dictionnary.container_dictionary
