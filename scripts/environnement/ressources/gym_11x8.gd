extends ClassMapObject

const GYM_FRONT_PATH = "res://scenes/environnement/ressources/gym_front.tscn"

func _body_entered_script(_body):
	pass

func _body_exited_script(_body):
	pass
	
func _specifics_parameters():
	if object_sprite.frame % 3 == 1:
		print("Spawn front needed !")
		var spawn_front = load(GYM_FRONT_PATH).instance()
		#get_parent().call_deferred("add_child", spawn_front)
		spawn_front.set_parameters(object_sprite.frame/3, position)

func _interact_action():
	pass
	
func _dialogue_feedback(_feedback):
	pass
	
