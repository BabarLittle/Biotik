"""=============================================================================
SceneManager.gd
============================================================================="""
extends Node2D


var next_scene = null
var player_location = Vector2(0,0)
var player_direction = Vector2(0,0)

enum TransitionType {NEW_SCENE, PARTY_SCENE, MENU_ONLY, BATTLE}
var transition_type = TransitionType.NEW_SCENE

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func transition_to_party_screen():
	transition_type = TransitionType.PARTY_SCENE
	$ScreenTransition/AnimationPlayer.play("FadeToBlack")
	
	
func transition_to_scene(new_scene : String, spawn_location, spawn_direction):
	next_scene = new_scene
	print(next_scene)
	player_direction = spawn_direction
	player_location = spawn_location
	transition_type = TransitionType.NEW_SCENE
	$ScreenTransition/AnimationPlayer.play("FadeToBlack")

func transition_battle(new_scene : String):
	next_scene = new_scene
	transition_type = TransitionType.BATTLE
	$ScreenTransition/AnimationPlayer.play("FadeToBlack")

func finished_fading():
	match transition_type:
		TransitionType.NEW_SCENE:
			$CurrentScene.get_child(0).queue_free()
			$CurrentScene.add_child(load(next_scene).instance())
			print(next_scene)
			
			var player = Utils.get_player()
			player.set_spawn(player_location, player_direction)
		TransitionType.PARTY_SCENE:
			$Menu.load_party_screen()
		TransitionType.MENU_ONLY:
			print("Success")
		TransitionType.BATTLE:
			$CurrentScene.get_child(0).queue_free()
			$CurrentScene.add_child(load(next_scene).instance())
	$ScreenTransition/AnimationPlayer.play("FadeToNormal")

