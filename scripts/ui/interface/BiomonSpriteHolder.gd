tool

extends Node2D

export(int) var biomon_id = 0 setget load_sprite_holder

func load_sprite_holder(value):
	biomon_id = value
	if value != 0:
		$Sprite.select_sprite(value)
		
