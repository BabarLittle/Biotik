extends Node2D

<<<<<<< Updated upstream
func _ready():
	$NinePatchRect.visible = false
	$Sprite.texture = null

func select_sprite(biomon_id=1, background = false):
	# Check if the id exists
	if DataRead.database.biodex.has(str(biomon_id)):
		# Check if the sprite exists
		if Directory.new().file_exists("res://assets/characters/biomons/" + DataRead.database.biodex[str(biomon_id)].name + ".png"):
			$Sprite.texture = load("res://assets/characters/biomons/" + DataRead.database.biodex[str(biomon_id)].name + ".png")
		else:
			print("WAR:select_sprite> Texture de '" + DataRead.database.biodex[str(biomon_id)].name + "' n'existe pas ! Return Unknown.png")
			$Sprite.texture = load("res://assets/characters/biomons/Unknown.png")
	else:
		print("WAR:select_sprite> La clé '" + str(biomon_id) + "' n'existe pas ! Return Unknown.png")
		$Sprite.texture = load("res://assets/characters/biomons/Unknown.png")
	
	if background:
		$NinePatchRect.visible = true
	else:
		$NinePatchRect.visible = false
=======
enum SpriteState {NONE, STATIC, FRONT, BACK, MINI}

var assets_directory = "res://assets/characters/biomons/"
var no_file_path = assets_directory + "NoFile.png"
var no_id_path = assets_directory + "NoId.png"
var unknown_path = assets_directory + "Unknwon.png"
var is_shiny = false
export(SpriteState) var sprite_state = SpriteState.NONE

func _ready():
	$AnimationPlayer.stop()
	print(sprite_state)
	print(sprite_state == 0)

func select_sprite(biomon_id=1, biomon_is_shiny=false, biomon_position=sprite_state):
	var sprite_path = ""
	sprite_state = biomon_position
	is_shiny = biomon_is_shiny
	$AnimationPlayer.stop()
	
	if sprite_state == SpriteState.NONE:
		sprite_path = unknown_path
		pass

	elif !DataRead.database.biodex.has(str(biomon_id)):
		sprite_path = no_id_path
		sprite_state = SpriteState.STATIC
		print("WAR:select_sprite> La clé '" + str(biomon_id) + "' n'existe pas ! Return NoId.png")
		pass
	
	elif !DataRead.is_biomon_known(biomon_id):
		sprite_path = unknown_path
		sprite_state = SpriteState.STATIC
		pass
		
	elif !Directory.new().file_exists(sprite_path):
		print("WAR:select_sprite> Texture de '" + DataRead.database.biodex[str(biomon_id)].name + "' n'existe pas ! Return NoFile.png")
		sprite_path = no_file_path
		pass
	
	else:
		sprite_path = assets_directory + DataRead.database.biodex[str(biomon_id)].name + ".png"
	
	load_sprite(sprite_path)

func load_sprite(file_path):
	visible = true
	set_active_tree()
	$Sprite.texture = load(file_path)
	
	match sprite_state:
		SpriteState.BACK:
			$AnimationPlayer.play("back_idle")
		SpriteState.FRONT:
			$AnimationPlayer.play("front_idle")
		SpriteState.STATIC:
			$AnimationPlayer.stop()
			$Sprite.scale = Vector2.ONE
			$Sprite.rotation = 0
			$Sprite.position = Vector2.ZERO
		SpriteState.MINI:
			$AnimationPlayer.play("mini")
		SpriteState.NONE:
			$AnimationPlayer.stop()
			visible = false

func set_active_tree():
	if is_shiny:
		$AnimationTreeNormal.active = false
		$AnimationTreeShiny.active = true
	else:
		$AnimationTreeNormal.active = true
		$AnimationTreeShiny.active = false

func load_animation(animation_name):
	$AnimationPlayer.play(animation_name)
>>>>>>> Stashed changes
