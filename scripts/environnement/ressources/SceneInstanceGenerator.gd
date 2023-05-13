extends TileMap

const RESSOURCES_PATH = "res://scenes/environnement/ressources/"
const SCENE_EXTENSION = ".tscn"
const DIGITS = 2

func _ready():
	var usedCells = get_used_cells()
	
	for i in usedCells.size():
		load_object(usedCells[i])
	
	clear()
	
func load_object(target):# Load with name of the scene.. Return scene path ?
	var object_to_load = tile_set.tile_get_name(get_cellv(target))
	var object_id = object_to_load.right(object_to_load.length()-DIGITS)
	
	var object_name = object_to_load.left(object_to_load.length()-(DIGITS+1))
	var path_object = RESSOURCES_PATH + object_name + SCENE_EXTENSION
	
	var object_instance = load(path_object).instance()
	
	object_instance.set_parameters(object_id, map_to_world(target))	
	get_parent().call_deferred("add_child", object_instance)

