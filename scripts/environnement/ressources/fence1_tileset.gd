extends ClassMapObject

func _body_entered_script(_body):
	pass

func _body_exited_script(_body):
	pass
	
func _specifics_parameters():
	for i in range(object_sprite.hframes * object_sprite.vframes):
		if i != object_sprite.frame:
			get_node("frame0"+str(i)).queue_free()
		else:
			get_node("frame0"+str(object_sprite.frame)).disabled = false


func _interact_action():
	pass
	
func _dialogue_feedback(_feedback):
	pass
	
