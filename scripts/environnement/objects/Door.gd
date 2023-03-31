extends Area2D

signal SignalNextScene

export(String, FILE) var next_scene_path = ""
export(bool) var is_invisibile = false
export (int) var id 

export (Vector2) var spawn_location = Vector2()
export (Vector2) var spawn_direction = Vector2()

onready var sprite = $Sprite
onready var animation = $AnimationPlayer

var target_door = false

func _ready():
	if is_invisibile:
		$Sprite.texture = null
	sprite.visible = false


func enter_door():
		animation.play("OpenDoor")
		

func close_door():
		animation.play("CloseDoor")

func door_closed():
	#Utils.get_scene_manager().transition_to_scene(next_scene_path, spawn_location, spawn_direction)
	print("'Door' emits signal to '" + Utils.get_current_scene().name + "' with '" + next_scene_path + "'")
	emit_signal("SignalNextScene", next_scene_path, spawn_location, spawn_direction)
	target_door = false


func _on_Door_body_entered(body):	
	if body.name == "Player":
		enter_door()
		close_door()

		



