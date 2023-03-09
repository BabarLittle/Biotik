extends Node2D

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
