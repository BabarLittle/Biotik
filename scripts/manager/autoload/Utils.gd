extends Node

<<<<<<< Updated upstream
<<<<<<< Updated upstream:scenes/manager/Utils.gd

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


=======
>>>>>>> Stashed changes:scripts/manager/autoload/Utils.gd
=======
>>>>>>> Stashed changes
func get_player():
	return get_node("../SceneManager/CurrentScene").get_children().back().find_node("Player")

func get_scene_manager():
	return get_node("../SceneManager")

func get_dialoguepopup():
	return get_node("../SceneManager/Interface/PopupDialog")

func get_menu():
	return get_node('../SceneManager/Menu')
