extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

const BiomonPartyScreen = preload("res://scenes/UI/Screen/PartyScreen.tscn")
const BiodexScreen = preload("res://scenes/UI/Screen/biodex.tscn")
const BiodexInfosScreen = preload("res://scenes/UI/Screen/biodex_infos.tscn")


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
