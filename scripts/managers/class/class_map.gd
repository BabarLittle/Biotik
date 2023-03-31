"""=============================================
File: class_map.gd
Author: Ska
Version: 0.1
Description:
	Class for creating maps. Includes all basic functions to communicate with the scene manager.

Changes: 
	0.1 (Ska)
		- file creation

============================================="""

extends Node2D

class_name ClassMap

# Set up signals
signal SignalSceneChanging # mandatory for the scene manager to work properly

# Set up variables
var scene_parameters = {} # mandatory dictionnary to pass parameters between scenes
var next_scene = null # Next scene of type String
var player
export (String) var location

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
	
	""" Load player position """
	player = Utils.get_player()
	player.set_spawn(scene_parameters.spawn_location, scene_parameters.spawn_direction)
	
	""" Ready function for inheritance """
	_load_map()

func _load_map():
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
func exit_scene(next_scene_path: String, spawn_location, spawn_direction, transition_name="FadeToBlack"):
	print("Signal receive by '" + self.name + "' with '" + next_scene_path + "'")
	""" set the dictionnary to be sent to the next scene """
	scene_parameters.spawn_location = spawn_location
	scene_parameters.spawn_direction = spawn_direction
	
	_pack_scene()
	
	""" once everything is done emit signal """
	emit_signal("SignalSceneChanging", next_scene_path, transition_name)

func _pack_scene():
	pass

""" Function that connects signals """
func signal_connect(door):
	assert(door.connect("SignalNextScene", self, "exit_scene") == 0, "ERR:signal_connect> 'SignalNextScene' failed to connect from '%s%%'" % door.name)
	assert(player.connect("player_entering_door_signal", door, "enter_door") == 0, "ERR:biodex_infos/_ready> Signal 'player_entering_door_signal' could not connect to '%s%%'" % door.name)
	assert(player.connect("player_entered_door_signal", door, "close_door") == 0, "ERR:biodex_infos/_ready> Signal 'player_entered_door_signal' could not connect to '%s%%'" % door.name)
	
	print(self.name + " successfully connected to 'SignalNextScene' from '" + door.name + "'")

""" Function that generate an encounter """
func generate_encounter(encounter_dict):
	scene_parameters.last_scene = self.filename
	#scene_parameters.encounter_dict = encounter_dict
	exit_scene("res://scenes/environnement/arena/EncounterBattle.tscn", scene_parameters.spawn_location, scene_parameters.spawn_direction, "BattleFlash")
	print("Encountered '" + encounter_dict.biomon_key + "' at level " + str(encounter_dict.level) + " !")

func get_scene_parameters():
	scene_parameters.spawn_location = Utils.get_player().position
	scene_parameters.spawn_direction = Utils.get_player().get_player_direction()
	print(scene_parameters)
	return scene_parameters
