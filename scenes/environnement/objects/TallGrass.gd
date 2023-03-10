extends Node2D
export(String, FILE) var next_scene_path = ""

onready var anim_player = $AnimationPlayer
const grass_overlay_texture = preload("res://Assets/Grass/stepped_tall_grass.png")
const grass_stepped_effect = preload("res://scenes/environnement/objects/AnimatedGrass.tscn")
var grass_overlay : TextureRect = null



var player_inside : bool = false

func _ready():
	var player = Utils.get_player()
	player.connect("player_moving_signal", self, "player_exiting_grass")
	player.connect("player_stopped_signal", self, "player_in_grass")

func player_exiting_grass():
	player_inside = false
	if is_instance_valid(grass_overlay):
		grass_overlay.queue_free()

func player_in_grass():
	if player_inside == true:
		var my_prob_battle = int(rand_range(0,100))
		if my_prob_battle >= 100:
			get_node(NodePath("/root/SceneManager")).transition_battle(next_scene_path)
		var grass_step_effect = grass_stepped_effect.instance()
		grass_step_effect.position = position
		print("grasse stepped on position: ",grass_step_effect.position)
		get_tree().current_scene.add_child(grass_step_effect)
		
		grass_overlay = TextureRect.new()
		grass_overlay.texture = grass_overlay_texture
		grass_overlay.rect_position = position
		get_tree().current_scene.add_child(grass_overlay)
		print("Grass overlay  position: ",grass_overlay.rect_position)
	

func _on_Area2D_body_entered(_body):
	player_inside = true
	anim_player.play("Stepped")
