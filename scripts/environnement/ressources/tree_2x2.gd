extends ClassMapObject

func _body_entered_script(_body):
	anime_tree(3)

func _body_exited_script(_body):
	pass
	
func _specifics_parameters():
	pass

func _interact_action():
	anime_tree(10)
	
func dialogue_feedback(_feedback):
	pass

func anime_tree(diff):
	object_sound.play()
	
	var new_tween = get_tree().create_tween()
	new_tween.set_trans(Tween.TRANS_BOUNCE)
	new_tween.set_parallel(false)
	new_tween.tween_property(object_sprite, "rotation_degrees", object_sprite.rotation_degrees+diff, 0.1).from(0)
	new_tween.tween_property(object_sprite, "rotation_degrees", object_sprite.rotation_degrees-diff, 0.1).from(object_sprite.rotation_degrees+diff)
	new_tween.tween_property(object_sprite, "rotation_degrees", object_sprite.rotation_degrees*0, 0.1).from(object_sprite.rotation_degrees-diff)
