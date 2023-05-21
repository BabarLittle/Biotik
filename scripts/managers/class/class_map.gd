extends Node2D

class_name ClassMap

enum EncounterZone {NONE=0, GROUND=1, WATER=2, TREE=3, FISHING=4}

# Set up signals
signal SignalSceneChanging # mandatory for the scene manager to work properly

# Set up variables
var scene_parameters = {} # mandatory dictionnary to pass parameters between scenes
var next_scene = null # Next scene of type String
var player
var ambient_light
var door_vector = Vector2(20, 20)
export (String) var location
export (bool) var self_ambient = false
export(String, FILE, "*.json") var encounter_file_name


func load_scene(inherited_parameters: Dictionary):
	""" set the dictionnary received from the last scene """
	scene_parameters = inherited_parameters
	
	""" get the ambient node and set it """
	ambient_light = get_node("AmbientLight")
	ambient_light.load_ambient_light(self_ambient)
	
	""" Load player position """
	player = Utils.get_player()
	var player_spawn = [Vector2.ZERO, Vector2.ZERO]

	player_spawn = calculate_player_spawn()
	if scene_parameters.door_id == null:
		player.set_spawn(scene_parameters.spawn_location, scene_parameters.spawn_direction)
	else:
		player.set_spawn(player_spawn[0]+player_spawn[1]*door_vector, player_spawn[1]*door_vector)
	
	if encounter_file_name != "":
		EncounterManager.load_encounter_dictionary(encounter_file_name)
	
	
	""" Ready function for inheritance """
	_load_map()

func _load_map():
	pass

func exit_scene(next_scene_path: String, door_id=null, transition_name="FadeToBlack"):
	print("Signal receive by '" + self.name + "' with '" + next_scene_path + "'")
	""" set the dictionnary to be sent to the next scene """
	scene_parameters.door_id = door_id
	get_scene_parameters()
	EncounterManager.free_dictionnary()
	
	_pack_scene()
	
	""" once everything is done emit signal """
	emit_signal("SignalSceneChanging", next_scene_path, transition_name)

func _pack_scene():
	pass

	
""" Function that generate an encounter """
func check_encounter(encounter_type):
	var encounter = EncounterManager.calculate_encounter(encounter_type)
	
	if encounter == null:
		return
	
	print(" > Encountered '" + encounter.biomon_key + "' at level " + str(encounter.level) + " !")

	scene_parameters.last_scene = self.filename
	scene_parameters.new_encounter = encounter
	player.set_control(false)
	exit_scene("res://scenes/environnement/arena/EncounterBattle.tscn", "null", "BattleFlash")

func get_scene_parameters():
	scene_parameters.spawn_location = Utils.get_player().position
	scene_parameters.spawn_direction = Utils.get_player().get_player_direction()
	print(scene_parameters)
	return scene_parameters
	
func calculate_player_spawn():
	if scene_parameters.door_id == null:
		return [scene_parameters.spawn_location, scene_parameters.spawn_direction]
	else:
		return $DoorContainer.find_door_parameters(scene_parameters.door_id)

func get_current_tileset():
	return $GroundLayer
