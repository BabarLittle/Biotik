extends Area2D

signal Signal_SceneSwitched

export(String, FILE) var next_scene_path = ""
export(bool) var is_invisibile = false
export (int) var id 

export (Vector2) var spawn_location = Vector2()
export (Vector2) var spawn_direction = Vector2()

onready var sprite = $Sprite
onready var animation = $AnimationPlayer

func _ready():
	if is_invisibile:
		$Sprite.texture = null
	sprite.visible = false
	connect("Signal_SceneSwitched", Utils.get_current_scene(), "exit_scene")

func enter_door():
		animation.play("OpenDoor")

func close_door():
		animation.play("CloseDoor")

func door_closed():
	#Utils.get_scene_manager().transition_to_scene(next_scene_path, spawn_location, spawn_direction)
	emit_signal("Signal_SceneSwitched", next_scene_path, spawn_location, spawn_direction)	


func _on_Door_body_entered(body):	
	if body.name == "Player":
		var player = Utils.get_player()
		player.connect("player_entering_door_signal", self, "enter_door")
		player.connect("player_entered_door_signal", self, "close_door")


