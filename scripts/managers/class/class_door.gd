extends StaticBody2D

class_name ClassDoor

enum ExitingDirection {UP, DOWN, LEFT, RIGHT}

export (String, FILE) var target_scene_path = ""
export (String) var door_name = ""
export (ExitingDirection) var exiting_direction = ExitingDirection.DOWN
export (bool) var animated_door = false
export (bool) var is_open = false
export (String, FILE) var sound_open_path = "res://assets/audio/environnement/sfx/door.mp3"
export (String, FILE) var sound_lock_path = "res://assets/audio/environnement/sfx/door_locked.mp3"

var is_active = true
var door_sprite
var sound_open
var sound_lock
var door_marker
var door_body

func _ready():
	door_sprite = $Sprite
	sound_open = $SfxOpen
	sound_lock = $SfxLock
	sound_open.stream = load(sound_open_path)
	sound_lock.stream = load(sound_lock_path)
	door_marker = $DoorMarker
	door_body = $CollisionShape2D
	
	unlock_door(is_open)
	
	_specific_parameters()
	
func _specific_parameters():
	pass

func get_player_vectors():
	var vector_direction
	#is_active = false 
	match exiting_direction:
		ExitingDirection.UP:
			vector_direction = Vector2.UP
		ExitingDirection.DOWN:
			vector_direction = Vector2.DOWN
		ExitingDirection.LEFT:
			vector_direction = Vector2.LEFT
		ExitingDirection.RIGHT:
			vector_direction = Vector2.RIGHT
		
	return [self.position, vector_direction]

func _on_DoorMarker_body_exited(body):
	_body_exited_script(body)
	if body.name == Utils.get_player().name:
		is_active = true

func _body_exited_script(_body):
	pass

func _interact_action():
	_specific_interactions()
	if is_open:
		return
	
	sound_lock.play()

func _specific_interactions():
	pass

func _on_DoorMarker_body_entered(body):
	_body_entered_script(body)
	if body.name == Utils.get_player().name and is_active:
		is_active = false
		if animated_door:
			var new_tween = get_tree().create_tween()
			new_tween.tween_property(door_sprite, "frame_coords", Vector2(door_sprite.frame_coords.x, door_sprite.vframes), 1)
			new_tween.tween_property(door_sprite, "frame_coords",  Vector2(door_sprite.frame_coords.x, 0), 1)
		sound_open.play()
		Utils.get_player().animationplayer.play("Disapear")
		Utils.get_current_scene().exit_scene(target_scene_path, door_name)

func _body_entered_script(_body):
	pass

func unlock_door(open=true):
	is_open = open
	door_body.disabled = is_open

func set_sprite_frame(frame):
	$Sprite.frame = frame
