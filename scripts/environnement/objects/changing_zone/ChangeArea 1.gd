extends Area2D

export(String, FILE) var next_scene_path = ""

export (Vector2) var spawn_location = Vector2()
export (Vector2) var spawn_direction = Vector2()
export (int) var id


func _ready():
	pass
	

func switch_area(id):
	Utils.get_scene_manager().transition_to_scene(next_scene_path, spawn_location, spawn_direction)
	print(id, ": ", next_scene_path)

	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ChangeArea_body_entered(body):
	var player = Utils.get_player()
	player.connect("player_entering_door_signal", self, "switch_area", [id])
	print(id)
