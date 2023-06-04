extends Node2D

export var biomon_id = 0

func select_sprite(value):
	biomon_id = value
	if value != 0:
		$BiomonSprite.select_sprite(value)
		
