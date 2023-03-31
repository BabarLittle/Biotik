extends Node2D

func load_sprite_holder(biomon_id=0):
	if biomon_id != 0:
		$Sprite.select_sprite(biomon_id)
