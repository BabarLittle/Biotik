# meta-name: Annoted menu screen
# meta-description: Base template with complete annoted code for screen generation in Biotik
"""=============================================
File: MainTitle.gd
Author: Ska
Version: 0.1
Description:
	Debug menu screen

Changes: 
	0.1
		- file creation

To-do: 
	-(...)
============================================="""

extends ClassScreen

var location = Vector2.ZERO
var direction = Vector2.DOWN

""" Called when the scene manager load the scene """
func _load_screen():	
	pass # Use this as the "ready" function

""" Called when the scene manager exit the scene """
func _pack_scene():
	# Use this to store some new keys into scene_parameters
	scene_parameters.spawn_location = location
	scene_parameters.spawn_direction = direction


""" CALLS FROM BUTTONS HERE """
func button_pressed(next_scene, location_scene, direction_scene):
	
	# If not a scene but biomon_gen... Gen a biomon (last button)
	if next_scene == "biomon_gen":
		var new_biomon = ClassBiomon.new(DataRead.database.biodex.keys(), [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20])
		$LbBiomon.text = new_biomon.name + " lv:" + str(new_biomon.level)
		$BiomonSprite.select_sprite(new_biomon.id, true)
	
	# Load the scene if specified
	elif !next_scene == "":
		location = location_scene
		direction = direction_scene
		emit_signal("SignalSceneChanging", next_scene)
		
	# No scene specified = pressed button not assigned
	else:
		print("No scene assigned !")
