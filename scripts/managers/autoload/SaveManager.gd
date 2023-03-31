extends Node

const SAVE_DIRECTORY_PATH = "res://data/saves/"
const SAVED_GAMES_PATH = SAVE_DIRECTORY_PATH + "saved_games.bsf"
const KEY_INFOS = "informaSk4"
const NEW_GAME_SCENE = "res://scenes/environnement/maps/01-kellen-bourg/01-PlayerHomeFloor2.tscn"

var saved_games_data = {}
var current_game_save_key = "game1"

var empty_data_dict = {
			"game1": "empty",
			"game2": "empty",
			"game3": "empty"
			}

var Dict_test = {
		"player_name": "L-Der",
		"player_title": "Grand maître",
		"time_played": "5h01",
		"current_scene_name": "Route 404",
		"biomons_seen": 151,
		"biomons_captured": 148,
		"picture_path": "res://assets/characters/npc/NPC 108.png",
		"badges": [1,1,1,1,0,1,1,1,0],
	}

func _ready():
	load_games_informations()

func create_save_file():
	var save_directory = Directory.new()
	if !save_directory.dir_exists(SAVE_DIRECTORY_PATH):
		save_directory.make_dir_recursive(SAVE_DIRECTORY_PATH)
		
	var save_file = File.new()
	var error = save_file.open(SAVED_GAMES_PATH, File.WRITE)
	if error == OK:
		save_file.store_var(empty_data_dict)
		save_file.close()

func save_game():
	var save_directory = Directory.new()
	if !save_directory.dir_exists(SAVE_DIRECTORY_PATH):
		save_directory.make_dir_recursive(SAVE_DIRECTORY_PATH)
	
	saved_games_data[current_game_save_key] = gather_current_game_data()
	
	var save_file = File.new()
	var error = save_file.open(SAVED_GAMES_PATH, File.WRITE)
	if error == OK:
		save_file.store_var(saved_games_data)
		save_file.close()

func load_games_informations():
	var save_file = File.new()
	
	if !save_file.file_exists(SAVED_GAMES_PATH):
		create_save_file()
	
	var file = File.new()
	var error = file.open(SAVED_GAMES_PATH, File.READ)
	if error == OK:
		saved_games_data = file.get_var()
		file.close()

func get_saved_informations(game_id:int = 0):
	if game_id == 0:
		return saved_games_data
	else:
		return saved_games_data["game"+str(game_id)].informations

func gather_current_game_data():
	var current_game_dictionnary = {
		"informations": {
			"save_key": current_game_save_key,
			"player_name": StoryManager.get_player_name(),
			"player_title": StoryManager.get_player_title(),
			"time_played": Utils.get_scene_manager().get_time_played(),
			"current_scene_name": Utils.get_scene_manager().get_current_scene_name(),
			"biomons_seen": PartyManager.get_nb_biomons_seen(),
			"biomons_captured": PartyManager.get_nb_biomons_captured(),
			"picture_path": Utils.get_player().get_node("Sprite").texture.get_load_path(),
			"badges": StoryManager.get_badges_array()
		},
		"SceneManager": Utils.get_scene_manager().saving_game_data(),
		"PartyManager": PartyManager.saving_game_data(),
		"StoryManager": StoryManager.saving_game_data()
	}
	return current_game_dictionnary

func loading_game(game_key):
	var game_data = saved_games_data[game_key]
	current_game_save_key = game_key
	var next_scene_path = ""
	
	if typeof(game_data) != TYPE_DICTIONARY:
		next_scene_path = NEW_GAME_SCENE
	else:
		Utils.get_scene_manager().loading_game_data(game_data.SceneManager)
		StoryManager.loading_game_data(game_data.StoryManager)
		PartyManager.loading_game_data(game_data.PartyManager)
		next_scene_path = game_data.SceneManager.current_scene
	Utils.get_scene_manager().handle_scene_changing(next_scene_path)
