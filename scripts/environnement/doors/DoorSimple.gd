tool
extends ClassDoor

export (int, "Red", "Green", "Brown", "Black", "Wood", "Weed", "Dark Wood", "White Wood") var door_skin setget set_skin

func _specifics_parameters():
	set_skin(door_skin)
	
func _specific_interactions():
	pass
	
func _body_entered_script(_body):
	pass

func _body_exited_script(_body):
	pass
	
func set_skin(skin_id):
	door_skin = skin_id
	set_sprite_frame(door_skin)
