"""=============================================
File: 01-PlayerHomeFloor1
Author: Ska
Version: 0.1
Description:
	(...)

Changes: 
	0.1 (Author)
		- file creation

============================================="""

extends ClassMap

""" Called when the scene manager load the scene """
func _load_map():
	""" Conecting doors signals """
	# Connect your doors signals here (using "signal_connect(door_name)")
	signal_connect($Sortie)
	signal_connect($Etage_1)

""" Called when the scene manager exit the scene """
func _pack_scene():
	# Use this to store some new keys into scene_parameter
	pass
