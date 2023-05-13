extends ClassMapObject

func _body_entered_script(_body):
	pass

func _body_exited_script(_body):
	pass
	
func _specifics_parameters():
	position += Vector2(-31, -49)
	Utils.get_next_scene().get_node("CollisionLayer").call_deferred("add_child", self)

func _interact_action():
	pass
	
func _dialogue_feedback(_feedback):
	pass
