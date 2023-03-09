# meta-name: Annoted biotik
# meta-description: Base template with complete annoted code for scene generation in Biotik
"""=============================================
File: 
Author: 
Version: 0.1
Description:
	(...)

Changes: 
	0.1
		- file creation

To-do: 
	-(...)
============================================="""

extends Node2D

# Set up signals
signal Signal_SceneChanging # mandatory for the scene manager to work properly

# Set up constants

# Set up variables
var scene_parameters = {} # mandatory dictionnary to pass parameters between scenes
var next_scene = null # Next scene of type String
var player

"""=====
Function load_scene
Author: Ska
	Function called when the scene manager is ready make the scene appears. Loads all relevant Data
	for the scene.

Arguments
	- inherited_parameters: dictionnary of parameters given by the last scene
====="""
func load_scene(inherited_parameters: Dictionary):
	""" set the dictionnary to be sent to the next scene """
	scene_parameters = inherited_parameters
	
	""" Load player position """
	player = Utils.get_player()
	player.set_spawn(scene_parameters.spawn_location, scene_parameters.spawn_direction)

"""=====
Function exit_scene
Author: Ska
	Function called when the player or UI exit the scene. It save the variables needed for the next
	and then proceeds to signal the scene manager it's ready to switch scene.

Arguments
	- next_scene_path: mandatory path of the next scene
	- the others arguments are up to the needs of the scene
====="""
func exit_scene(next_scene_path: String, spawn_location, spawn_direction):
	""" set the dictionnary to be sent to the next scene """
	scene_parameters.spawn_location = spawn_location
	scene_parameters.spawn_direction = spawn_direction
	
	""" once everything is done emit signal """
	emit_signal("Signal_SceneChanging", next_scene_path)
