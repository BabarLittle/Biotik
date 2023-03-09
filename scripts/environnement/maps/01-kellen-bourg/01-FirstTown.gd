# meta-name: Annoted biotik scene
# meta-description: Base template with complete annoted code for scene generation in Biotik
"""=============================================
File: 01-FirstTown.gd
Author: Ska
Version: 0.1
Description:
	The first town of the game. Where it all begins

Changes: 
	0.1
		- file creation

To-do: 
	-(...)
============================================="""

extends ClassMap

""" Called when the scene manager load the scene """
func _load_map():
	""" Conecting doors signals """
	signal_connect($YSort/House/Door)

""" Called when the scene manager exit the scene """
func _pack_scene():
	# Use this to store some new keys into scene_parameter
	pass
