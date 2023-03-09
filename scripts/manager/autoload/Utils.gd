extends Node

func get_player():
	return get_node("../SceneManager/CurrentScene").get_children().back().find_node("Player")

func get_scene_manager():
	return get_node("../SceneManager")

func get_current_scene():
	return get_node("../SceneManager/CurrentScene").get_child(0)

func get_dialoguepopup():
	return get_node("../SceneManager/Interface/PopupDialog")

func get_menu():
	return get_node('../SceneManager/Menu')
