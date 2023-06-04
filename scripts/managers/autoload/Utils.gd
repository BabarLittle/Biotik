extends Node

const SOURCE = "../SceneManager/"

func get_player():
	return get_node_or_null(SOURCE + "CurrentScene").get_children().back().find_node("Player")


func get_scene_manager():
	return get_node("../SceneManager")


func get_current_scene():
	return get_node(SOURCE + "CurrentScene").get_child(0)
	

func get_next_scene():
	if get_node(SOURCE + "CurrentScene").get_child_count() > 1:
		return get_node(SOURCE + "CurrentScene").get_child(1)
	else:
		return null


func get_menu():
	return get_node_or_null(SOURCE + "Menu")


func get_party_manager():
	return get_node_or_null(SOURCE + "CurrentScene").get_children().back().find_node("Player").find_node("PartyManager")


func get_dialogue_manager():
	return get_node(SOURCE + "DialogueManager")
	

func get_game_timer():
	return get_node(SOURCE + "GameTimer")

