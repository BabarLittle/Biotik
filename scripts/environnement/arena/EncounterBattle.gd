extends Node2D


# Set up signals
signal SignalSceneChanging # mandatory for the scene manager to work properly
signal SignalBroadcastEvent

# Set up variables
var scene_parameters = {} # mandatory dictionnary to pass parameters between scenes

func load_scene(inherited_parameters: Dictionary):
	""" set the dictionnary sent by the last scene """
	scene_parameters = inherited_parameters
	
	print("Loading scene '" + name + "' ...")
	
	

func exit_scene(next_scene_path: String):
	print("Signal sent by '" + self.name + "' with '" + next_scene_path + "'")
	print("packing screen '" + name + "' ...")
	
	""" once everything is done emit signal """
	emit_signal("SignalSceneChanging", next_scene_path)

func process_event(event):
	pass

func process_battle():
	pass
