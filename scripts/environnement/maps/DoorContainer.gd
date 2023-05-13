extends Node2D

func find_door_parameters(door_id):
	for child in get_children():
		if child.door_name == door_id:
			return child.get_player_vectors()
	
	print("Error, door name " + door_id + " not found !")
	return [Vector2.ZERO, Vector2.DOWN]
