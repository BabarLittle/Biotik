extends ClassMapObject

func _body_entered_script(_body):
	anime_tree(1)

func _body_exited_script(_body):
	pass
	
func _specifics_parameters():
	pass

func _interact_action():
	Utils.get_dialogue_manager().submit_dialogue(self, "tree")
	
func dialogue_feedback(feedback):
	if feedback == "true":
		anime_tree(20)
		roll_encounter()
	Utils.get_dialogue_manager().close_dialogue()

func anime_tree(diff):
	object_sound.play()
	
	var new_tween = get_tree().create_tween()
	new_tween.set_trans(Tween.TRANS_BOUNCE)
	new_tween.tween_property(object_sprite, "rotation_degrees", object_sprite.rotation_degrees+diff, 0.1).from_current()
	new_tween.tween_property(object_sprite, "rotation_degrees", object_sprite.rotation_degrees-diff, 0.1).from(diff)
	new_tween.tween_property(object_sprite, "rotation_degrees", object_sprite.rotation_degrees, 0.1).from(object_sprite.rotation_degrees-diff)

