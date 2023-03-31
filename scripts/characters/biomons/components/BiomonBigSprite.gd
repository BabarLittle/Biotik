extends Sprite

enum SpriteState {ANIMATED, STATIC, MINI}
var BiomonAnimationState = { "IS_SHINY": "shiny_",
	"IS_NOT_SHINY": "normal_",
	"SHOWING_BACK": "back_",
	"SHOWING_FRONT": "front_"
	}
var biomons_assets_directory = "res://assets/characters/biomons/"
var no_file_path = biomons_assets_directory + "NoFile.png"
var no_id_path = biomons_assets_directory + "NoId.png"
var unknown_path = biomons_assets_directory + "Unknown.png"
var biomon_id = 1

var biomon_showing_player = BiomonAnimationState.SHOWING_FRONT
var in_state = BiomonAnimationState.IS_NOT_SHINY
var while_action_is = "idle"
export(SpriteState) var sprite_state = SpriteState.STATIC

onready var animation_player = $AnimationTree.get("parameters/playback")

func _ready():
	animation_player.start("RESET")
	animation_player.stop()
	visible = false

func select_sprite(biomon_sprite_id=1, sprite_is_static=true, biomon_is_shiny=false, biomon_is_showing_back=false, sprite_is_mini=false):
	var sprite_path = ""
	if typeof(biomon_sprite_id) == TYPE_INT:
		biomon_id = biomon_sprite_id
	else:
		biomon_id = int(biomon_sprite_id)
	
	if biomon_is_shiny:
		in_state = BiomonAnimationState.IS_SHINY
	else:
		in_state = BiomonAnimationState.IS_NOT_SHINY
	
	if biomon_is_showing_back:
		biomon_showing_player = BiomonAnimationState.SHOWING_BACK
	else:
		biomon_showing_player = BiomonAnimationState.SHOWING_FRONT

	if !DataRead.database.biodex.has(str(biomon_sprite_id)):
		sprite_path = no_id_path
		sprite_state = SpriteState.STATIC
		print("WAR:select_sprite> La clé '" + str(biomon_id) + "' n'existe pas ! Return NoId.png")
		pass
	
	elif DataRead.get_biomon_known_state(biomon_id) == 0:
		sprite_path = unknown_path
		sprite_state = SpriteState.STATIC
		pass
		
	elif !Directory.new().file_exists(biomons_assets_directory + DataRead.database.biodex[str(biomon_id)].name + ".png"):
		sprite_path = no_file_path
		sprite_state = SpriteState.STATIC
		print("WAR:select_sprite> Texture de '" + DataRead.database.biodex[str(biomon_id)].name + "' n'existe pas ! Return NoFile.png")
		pass
	
	else:
		sprite_path = biomons_assets_directory + DataRead.database.biodex[str(biomon_id)].name + ".png"
		if sprite_is_mini:
			sprite_state = SpriteState.MINI
		elif sprite_is_static:
			sprite_state = SpriteState.STATIC
		else:
			sprite_state = SpriteState.ANIMATED

	load_sprite(sprite_path)

func load_sprite(file_path):
	texture = load(file_path)
	visible = true
	animation_player.start("RESET")
	
	match sprite_state:
		SpriteState.ANIMATED:
			load_animation()
		SpriteState.STATIC:
			animation_player.stop()
		SpriteState.MINI:
			animation_player.travel("mini")

func load_animation(action_name="idle"):
	while_action_is = action_name
	animation_player.travel(biomon_showing_player + in_state + while_action_is)

