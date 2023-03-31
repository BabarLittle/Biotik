# meta-name: Annoted biotik scene
# meta-description: Base template with complete annoted code for scene generation in Biotik

""" First-town main map"""
extends ClassMap

func _init():
	if Utils.get_player() != null:
		scene_parameters.spawn_location = Utils.get_player().position
		scene_parameters.spawn_direction = Utils.get_player().get("parameters/Idle/blend_position")

""" Called when the scene manager load the scene """
func _load_map():
	# Connect doors signals here
	signal_connect($YSort/House/Door)

""" Called when the scene manager exit the scene """
func _pack_scene():
	# Use this to store some new keys into scene_parameter
	pass
