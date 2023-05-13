extends ClassMapObject

const SOUND_CUT_PATH = "res://assets/audio/sfx/cut.mp3"

func _body_entered_script(_body):
	anime_bush()

func _body_exited_script(_body):
	pass
	
func _specifics_parameters():
	pass

func _interact_action():
	if StoryManager.get_player_tools("scizor"):
		cut_bush()
	else:
		Utils.get_dialogue_manager().submit_dialogue(self, "bush_no_cut")
	
	
func dialogue_feedback(_feedback):
	pass

func anime_bush():
	object_sound.stream = load(sound_file)
	object_sound.volume_db = -30
	object_sound.play()
	var new_tween = get_tree().create_tween()
	new_tween.set_trans(Tween.TRANS_BOUNCE)
	new_tween.tween_property(object_sprite, "scale", Vector2(0.9, 1.1), 0.1).from_current()
	new_tween.tween_property(object_sprite, "scale", Vector2(1.1, 0.9), 0.1).from(Vector2(0.9, 1.1))
	new_tween.tween_property(object_sprite, "scale", object_sprite.scale, 0.1).from(Vector2(1.1, 0.9))
	
func cut_bush():
	var new_tween = get_tree().create_tween()
	object_sound.stream = load(SOUND_CUT_PATH)
	object_sound.volume_db = 0
	object_sound.play()
	new_tween.tween_property(object_sprite, "frame", 4, 0.1).from_current()
	new_tween.tween_property(object_sprite, "frame", object_sprite.hframes-1, 0.4).from(4)
	set_collision_layer_bit(1, false)
	set_collision_layer_bit(0, false)
	set_collision_mask_bit(1, false)
	set_collision_mask_bit(0, false)
	Utils.get_player().set_control(true)
