extends Sprite

func select_sprite(biomon_id=1):
	# Check if the id exists
	if DataRead.database.biodex.has(str(biomon_id)):
		# Check if the sprite exists
		if Directory.new().file_exists("res://Assets/Biomons/" + DataRead.database.biodex[str(biomon_id)].name + ".png"):
			texture = load("res://Assets/Biomons/" + DataRead.database.biodex[str(biomon_id)].name + ".png")
		else:
			print("WAR:select_sprite> Texture de '" + DataRead.database.biodex[str(biomon_id)].name + "' n'existe pas ! Return Unknown.png")
			texture = load("res://Assets/Biomons/Unknown.png")
	else:
		print("WAR:select_sprite> La clé '" + str(biomon_id) + "' n'existe pas ! Return Unknown.png")
		texture = load("res://Assets/Biomons/Unknown.png")
