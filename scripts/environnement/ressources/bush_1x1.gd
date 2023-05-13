extends ClassMapObject

func _body_entered_script(_body):
	anime_bush()

func _body_exited_script(_body):
	pass
	
func _specifics_parameters():
	pass

func _interact_action():
	anime_bush()
	
func dialogue_feedback(_feedback):
	pass

func anime_bush():
	object_sound.play()
	var new_tween = get_tree().create_tween()
	new_tween.set_trans(Tween.TRANS_BOUNCE)
	new_tween.tween_property(object_sprite, "scale", Vector2(0.9, 1.1), 0.1).from_current()
	new_tween.tween_property(object_sprite, "scale", Vector2(1.1, 0.9), 0.1).from(Vector2(0.9, 1.1))
	new_tween.tween_property(object_sprite, "scale", Vector2(1, 1), 0.1).from(Vector2(1.1, 0.9))
	
