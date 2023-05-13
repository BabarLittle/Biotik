extends Node

var player_name = "L-Der"
var player_title_list = ["Jeune pousse"]
var player_current_title = 0
var story_dictionary = {}
var other_dialogues_dictionary = {}

func get_player_name():
	return player_name
	
func get_player_title():
	return player_title_list[player_current_title]

func get_badges_array():
	return [0,0,0,0,0,0,0,0,0]

func saving_game_data():
	var saved_dictionary = {
		"player_name": player_name,
		"player_title_list": player_title_list,
		"player_current_title": player_current_title,
		"story_dictionary": story_dictionary,
		"other_dialogues_dictionary": other_dialogues_dictionary
	}
	return saved_dictionary

func loading_game_data(game_dictionnary):
	player_name = game_dictionnary.player_name
	player_title_list = game_dictionnary.player_title_list
	player_current_title = game_dictionnary.player_current_title
	story_dictionary = game_dictionnary.story_dictionary
	other_dialogues_dictionary = game_dictionnary.other_dialogues_dictionary

func new_game(_game_id):
	pass

func get_player_tools(_which = null):
	return true
