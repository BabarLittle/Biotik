# meta-name: Annoted menu screen
# meta-description: Base template with complete annoted code for screen generation in Biotik
"""=============================================
File: world_map.gd
Author: Ska
Version: 0.1
Description:
	Just doing the global functions for now.

Changes: 
	0.1
		- file creation

To-do: 
	-Make differents mode for the map ? Or make 3 differents map scene ?
============================================="""

extends ClassScreen

# Set up signals

# Set up constants
enum MapMode {BIOMON_ZONE, FLY, NORMAL}

# Set up variables
var map_mode = MapMode.NORMAL

"""=====
Function _load_screen()
Author: Ska
	Function called when the scene manager is ready to make the scene appears. Loads all relevant 
	Data for the scene.

Arguments
	- inherited_parameters: dictionnary of parameters given by the last scene
====="""
func _load_screen():
	pass
	

"""=====
Function _pack_scene
Author: Ska
	Function called when the player exit the scene or exit one of the UI menu screens. 
	It save the variables needed for the next scene and then proceeds to signal the scene manager 
	it needs to switch scene.

Arguments
	- next_scene_path: mandatory path of the next scene
	- the others arguments are up to the needs of the scene
====="""
func _pack_scene():
	""" set the dictionnary to be sent to the next scene """
	#...
	pass

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		exit_scene("res://scenes/ui/screens/biodex/BiodexInfos.tscn")
