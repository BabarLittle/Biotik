tool

extends ClassDoor

export (int, "Blue", "Red", "Yellow", "Green", "Black", "Grey") var door_skin setget set_skin

func _specifics_parameters():
	set_skin(door_skin)
	
func set_skin(skin_id):
	door_skin = skin_id
	set_sprite_frame(door_skin)
