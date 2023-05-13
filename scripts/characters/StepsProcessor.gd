extends Node2D

onready var audio = $SfxSteps
onready var particles = preload("res://scenes/characters/ParticlesSteps.tscn")
var current_map_set = null

enum TerrainType {GRASS, SAND, WOOD, STONE, GRAVEL, DIRT, SNOW}

var terrain_type = TerrainType.GRASS

export (String, FILE) var sfx_grass = ""
export (String, FILE) var sfx_sand = ""
export (String, FILE) var sfx_stone = ""
export (String, FILE) var sfx_wood = ""
export (String, FILE) var sfx_gravel = ""
export (String, FILE) var sfx_metal = ""
export (String, FILE) var sfx_snow = ""
export (String, FILE) var sfx_dirt = ""

func _ready():
	pass #current_map_set = Utils.get_current_scene().get_current_tileset()
	
	
func step_processing():
	if current_map_set == null:
		current_map_set = Utils.get_current_scene().get_current_tileset()
		
	var foot_prints = particles.instance()
	Utils.get_current_scene().add_child(foot_prints)
	foot_prints.position = get_parent().position
	get_terrain_type()
	
func get_terrain_type():
	var tile_position = current_map_set.world_to_map(get_parent().position)
	var tile_id = current_map_set.get_cellv(tile_position)
	var tile_name = current_map_set.tile_set.tile_get_name(tile_id)
	print(tile_name)
	
	if "grass" in tilename:
		terrain_type = TerrainType.GRASS
	elif "sand" in tilename:
		terrain
