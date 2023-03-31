"""=============================================
File: class_screen.gd
Author: Ska
Version: 0.1
Description:
	Class for creating maps. Includes all basic functions to communicate with the scene manager.

Changes: 
	0.1 (Ska)
		- file creation

============================================="""

extends CanvasLayer

class_name ClassScreen

# Set up signals
signal SignalSceneChanging # mandatory for the scene manager to work properly

# Set up variables
var scene_parameters = {} # mandatory dictionnary to pass parameters between scenes
var next_scene = null # Next scene of type String

"""=====
Function load_scene
Author: Ska
	Function called when the scene manager is ready to make the scene appears. Loads all relevant 
	Data for the scene.

Arguments
	- inherited_parameters: dictionnary of parameters given by the last scene
====="""
func load_scene(inherited_parameters: Dictionary):
	""" set the dictionnary to be sent to the next scene """
	scene_parameters = inherited_parameters
	print("loading screen '" + name + "' ...")
	""" Ready function for inheritance """
	_load_screen()
	print(name + " loaded !")

func _load_screen():
	pass

"""=====
Function exit_scene
Author: Ska
	Function called when the player exit the scene or exit one of the UI menu screens. 
	It save the variables needed for the next scene and then proceeds to signal the scene manager 
	it needs to switch scene.

Arguments
	- next_scene_path: mandatory path of the next scene
====="""
func exit_scene(next_scene_path: String):
	print("class_screen Signal receive by '" + self.name + "' with '" + next_scene_path + "'")
	print("packing screen '" + name + "' ...")
	_pack_scene()

	""" once everything is done emit signal """
	if next_scene_path == "menu":
		Utils.get_menu().unload_screen()
	else:
		Utils.get_scene_manager().handle_scene_changing(next_scene_path, "FadeToWhite")

func _pack_scene():
	pass
"""
func _unhandled_input(event):
	if event.is_action_pressed("menu"):
		emit_signal("SignalSceneChanging", "menu")
"""
