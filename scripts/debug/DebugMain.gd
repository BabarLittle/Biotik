extends ClassScreen

var loading_screen = "res://scenes/ui/screens/loadgame/LoadGameScreenMain.tscn"

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
	scene_parameters.door_id = null
	print(scene_parameters)


""" CALLS FROM BUTTONS HERE """
func button_pressed(next_scene, location_scene, direction_scene):
	print("Button pressed with " + next_scene)
	# If not a scene but biomon_gen... Gen a biomon (last button)
	if next_scene == "load_data":
		emit_signal("SignalSceneChanging", loading_screen)

	# Load the scene if specified
	elif next_scene != "":
		location = location_scene
		direction = direction_scene
		print(next_scene)
		exit_scene(next_scene)
		
	# No scene specified = pressed button not assigned
	else:
		print("No scene assigned !")
