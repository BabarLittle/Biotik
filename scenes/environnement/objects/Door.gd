extends Area2D

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
	
func enter_door():
		animation.play("OpenDoor")
	

func close_door():
		animation.play("CloseDoor")
	
	
func door_closed():
	Utils.get_scene_manager().transition_to_scene(next_scene_path, spawn_location, spawn_direction)
	

	


func _on_Door_body_entered(body):	
	var player = Utils.get_player()
	if body.name == "Player":
		print('test')
		player.connect("player_entering_door_signal", self, "enter_door")
		player.connect("player_entered_door_signal", self, "close_door")


