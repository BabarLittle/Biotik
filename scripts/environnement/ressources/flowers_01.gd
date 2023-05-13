extends ClassMapObject

var x_origin = 0
var y_origin = 0

func _body_entered_script(_body):
	var temp_tween = get_tree().create_tween()
	temp_tween.set_parallel(true)
	temp_tween.tween_property(object_sprite, "scale", Vector2(1.1, 0.8), 0.1)
	temp_tween.tween_property(object_sprite, "position", Vector2(x_origin, y_origin + abs(15-16*0.8)), 0.1)

func _body_exited_script(_body):
	var temp_tween = get_tree().create_tween()
	temp_tween.set_parallel(true)
	temp_tween.tween_property(object_sprite, "scale", Vector2(1, 1), 0.1)
	temp_tween.tween_property(object_sprite, "position", Vector2(x_origin, y_origin), 0.1)
	
func _specifics_parameters():
	var temp_frame = object_sprite.frame
	object_sprite.frame = 0
	object_sprite.region_enabled = true
	object_sprite.set_region_rect(Rect2(16*temp_frame, 0, 16, 16*5))
	object_sprite.hframes = 1
	$AnimationPlayer.play("idle")
	
	x_origin = object_sprite.position.x
	y_origin = object_sprite.position.y

func _interact_action():
	pass
	
func _dialogue_feedback(_feedback):
	pass
	
