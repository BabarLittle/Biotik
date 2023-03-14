<<<<<<< Updated upstream:scenes/manager/SceneManager.gd
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

=======
"""=============================================
File: SceneManager
Author: Babar
Version: 0.2
Description:
	Script that controls the switching between the different maps, the menu 
	scenes and battle scenes
	NOTE: menu screens manage themselves once loaded
	
	Structure of the algorithm : 
		1. Player enters door / leaves area / press MenuButton
		2. current_scene enters "exit_scene()" GDScriptFunctionState
			- Saves whathever data that needs to be transferred to next_scene
			- Emit "SignalSceneChanging" to the SceneManager
		3. SceneManager enters "handle_scene_changed"
			- Load and hide the next scene
			- Play the correct Animation
		4. AnimationPlayer signals the end of the Animation
		5. SceneManager acts according to the animation name
			- "FadeToBlack" delete current scene and makes the next one VisibilityEnabler
		6. Reset scene variables and set new ones

Changes:
	0.1 (Babar)
		- File creation (Babar)
	0.2.2023.3.4 (Ska)
		- Changed functions to make the whole file more dynamic (Ska)
		- Added code annotations
	0.2.2023.3.7 (Ska)
		- Updated with new class system
	
To-do:
	- Implement funky and dynamics transitions to battle scene
	- Add switching sounds
	- Review / redo the function '_on_AnimationPlayer_animation_finished()'
============================================="""

extends Node2D

# Setting constants and enums
enum ScreenLoaded {SCENE, MENU_SCREEN, BATTLE_SCREEN, TITLE_SCREEN, JUST_MENU, DIALOGUE}

# Setting variables
var scene_parameters = {} # mandatory dictionnary to pass parameters between scenes
var next_scene = null # Next scene of type String
var screen_loaded = ScreenLoaded.TITLE_SCREEN

# Setting onready var
onready var first_scene = "res://scenes/debug/DebugMain.tscn" # First scene of the game
onready var current_scene = null

"""=====
Function _ready()
Author: Ska
	- Initialise variables :
		-> Connect signal from the first scene (current_scene)
====="""
func _ready() -> void:
	print("Loading first scene : " + first_scene)
	current_scene = load(first_scene).instance()
	$CurrentScene.add_child(current_scene)
	current_scene.connect("SignalSceneChanging", self, "handle_scene_changing")
	var temp_dict = {"spawn_location": Vector2(80, 96), "spawn_direction": Vector2.UP}
	current_scene.load_scene(temp_dict)
	

"""=====
Function handle_scene_changing()
Author: Ska
	- Occurs when receiving the signal "Signal_SceneChanged".
	- Effectivly switch the scene once it's loaded.
	
Arguments:
	- next_level_name: String passed by the current scene to determines wich scene is the next
	- transition_name: String passed by the current scene to choose the animation played
====="""
func handle_scene_changing(next_scene_name: String, transition_name:String="FadeToBlack"):
	print("handle_scene_changing('" + next_scene_name + "')")
	""" Check if the scene exists """
	var check_scene_name = File.new()
	assert(check_scene_name.file_exists(next_scene_name), "The specified scene '%s%%' does not exist!" % next_scene_name)
	
	""" Check if the animation exists """
	assert($ScreenTransition/AnimationPlayer.has_animation(transition_name), "The specified animation '%s%%' does not exist in the AnimationPlayer!" % transition_name)
	
	""" Main body of the function """
	next_scene = load(next_scene_name).instance()
	next_scene.visible = false
<<<<<<< Updated upstream
	print(next_scene_name + " loaded")
	$ScreenTransition/AnimationPlayer.play(transition_name)
	
	""" Determines what the next scene is """
=======
	print(next_scene.name + " loaded")
	$ScreenTransition/AnimationPlayer.play(transition_name)
	
	""" Determines what the next scene is """
	
		
	if "main" in next_scene_name:
		screen_loaded = ScreenLoaded.TITLE_SCREEN
	elif "screens" in next_scene_name:
		screen_loaded = ScreenLoaded.MENU_SCREEN
	elif "arena" in next_scene_name:
		screen_loaded = ScreenLoaded.BATTLE_SCREEN
	elif "maps" in next_scene_name:
		screen_loaded = ScreenLoaded.SCENE
>>>>>>> Stashed changes
	

"""=====
Function _on_AnimationPlayer_animation_finished()
Author: Ska
	- Occurs when receiving the animation ending signal from $ScreenTransition/AnimationPlayer
	
Arguments:
	- anim_name: String that contains the name of the animation that just finished. Automaticly 
	generated by the AnimationPlayer
====="""
func _on_AnimationPlayer_animation_finished(anim_name):
	var next_animation_name = ""
	
	match screen_loaded:
		ScreenLoaded.SCENE:
			next_animation_name = "FadeToNormal"
		ScreenLoaded.JUST_MENU:
			next_animation_name = "FadeToNormal"
		ScreenLoaded.MENU_SCREEN:
			next_animation_name = "FadeWhiteToNormal"
		ScreenLoaded.BATTLE_SCREEN:
			next_animation_name = "FadeToNormal"
		ScreenLoaded.TITLE_SCREEN:
			next_animation_name = "FadeToNormal"
	
<<<<<<< Updated upstream
	""" To rewrite... a simpler way exists """
	match anim_name:
		"FadeToBlack":
			$CurrentScene.add_child(next_scene)
			assert(next_scene.connect("SignalSceneChanging", self, "handle_scene_changing")==0, "ERR:SceneManager/animation_finished> Scene manager failed to connect to 'SignalSceneChanging' from '%s%%'" % next_scene.filename)
			next_scene.load_scene(current_scene.scene_parameters)  
			next_scene.visible = true
			current_scene.queue_free()
			current_scene = next_scene
			if screen_loaded == ScreenLoaded.JUST_MENU:
				$Menu.menu.visible = true
				var player = Utils.get_player()
				player.set_physics_process(false)
				$Menu/NinePatchRect/VBoxContainer/Biomons.grab_focus()
			next_scene = null
			$ScreenTransition/AnimationPlayer.play(next_animation_name)
		"FadeToWhite":
			$CurrentScene.add_child(next_scene)
			assert(next_scene.connect("SignalSceneChanging", self, "handle_scene_changing")==0, "ERR:SceneManager/animation_finished> Scene manager failed to connect to 'SignalSceneChanging' from '%s%%'" % next_scene.filename)
			print('loading')
			next_scene.load_scene(current_scene.scene_parameters)  
			next_scene.visible = true
			current_scene.queue_free()
			current_scene = next_scene
			if screen_loaded == ScreenLoaded.JUST_MENU:
				$menu.visible = true
				var player = Utils.get_player()
				player.set_physics_process(false)
				$Menu/NinePatchRect/VBoxContainer/Biomons.grab_focus()
			next_scene = null
			$ScreenTransition/AnimationPlayer.play(next_animation_name)
	
	
>>>>>>> Stashed changes:scripts/manager/SceneManager.gd
=======
	if not "Normal" in anim_name :
		$CurrentScene.add_child(next_scene)
		assert(next_scene.connect("SignalSceneChanging", self, "handle_scene_changing")==0, "ERR:SceneManager/animation_finished> Scene manager failed to connect to 'SignalSceneChanging' from '%s%%'" % next_scene.filename)
		print('loading')
		next_scene.load_scene(current_scene.scene_parameters)  
		next_scene.visible = true
		current_scene.queue_free()
		current_scene = next_scene
		if screen_loaded == ScreenLoaded.JUST_MENU:
			$menu.visible = true
			var player = Utils.get_player()
			player.set_physics_process(false)
			$Menu/NinePatchRect/VBoxContainer/Biomons.grab_focus()
		next_scene = null
		$ScreenTransition/AnimationPlayer.play(next_animation_name)	
>>>>>>> Stashed changes