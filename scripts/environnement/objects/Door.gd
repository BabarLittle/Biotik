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
	if target_door:
		animation.play("OpenDoor")
		print(name + " is target")

func close_door():
	if target_door:
		animation.play("CloseDoor")

func door_closed():
	#Utils.get_scene_manager().transition_to_scene(next_scene_path, spawn_location, spawn_direction)
	print("'Door' emits signal to '" + Utils.get_current_scene().name + "' with '" + next_scene_path + "'")
	emit_signal("SignalNextScene", next_scene_path, spawn_location, spawn_direction)
	target_door = false


func _on_Door_body_entered(body):	
	print("Door_body_entered")
	if body.name == "Player":
		print("Player entered the door '" + self.name + "'")
		
		"""var player = Utils.get_player()
		assert(player.connect("player_entering_door_signal", self, "enter_door") == 0, "ERR:biodex_infos/_ready> Signal 'player_entering_door_signal' could not connect to '%s%%'" % name)
		assert(player.connect("player_entered_door_signal", self, "close_door") == 0, "ERR:biodex_infos/_ready> Signal 'player_entered_door_signal' could not connect to '%s%%'" % name)"""


