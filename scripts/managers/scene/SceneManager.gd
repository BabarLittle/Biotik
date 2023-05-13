extends Node2D

# Setting constants and enums
enum ScreenLoaded {SCENE, MENU_SCREEN, BATTLE_SCREEN, TITLE_SCREEN, JUST_MENU, DIALOGUE}

# Setting variables
var scene_parameters = {} # mandatory dictionnary to pass parameters between scenes
var next_scene = null
var screen_loaded = ScreenLoaded.TITLE_SCREEN
var minutes_passed = 0

# Setting onready var
onready var first_scene = "res://scenes/debug/DebugMain.tscn" # First scene of the game
onready var current_scene = null

func _ready() -> void:
	print("Loading first scene : " + first_scene)
	current_scene = load(first_scene).instance()
	$CurrentScene.add_child(current_scene)
	current_scene.connect("SignalSceneChanging", self, "handle_scene_changing")
	var temp_dict = {"spawn_location": Vector2(80, 96), "spawn_direction": Vector2.UP}
	current_scene.load_scene(temp_dict)
	Utils.get_dialogue_manager().visible = false

func handle_scene_changing(next_scene_name: String, transition_name:String="FadeToBlack"):
	print("handle_scene_changing('" + next_scene_name + "')")
	""" Check if the scene exists """
	var check_scene_name = File.new()
	assert(check_scene_name.file_exists(next_scene_name), "The specified scene " + next_scene_name + " does not exist!")
	
	""" Check if the animation exists """
	assert($ScreenTransition/AnimationPlayer.has_animation(transition_name), "The specified animation '%s%%' does not exist in the AnimationPlayer!" % transition_name)
	
	""" Main body of the function """
	next_scene = load(next_scene_name).instance()
	next_scene.visible = false
	$ScreenTransition/AnimationPlayer.play(transition_name)
	
	""" Determines what the next scene is """
	$GameTimer.start()
	if "main" in next_scene_name.to_lower():
		screen_loaded = ScreenLoaded.TITLE_SCREEN
		$GameTimer.stop()
	elif "screens" in next_scene_name.to_lower():
		screen_loaded = ScreenLoaded.MENU_SCREEN
	elif "arena" in next_scene_name.to_lower():
		screen_loaded = ScreenLoaded.BATTLE_SCREEN
	elif "maps" in next_scene_name.to_lower():
		screen_loaded = ScreenLoaded.SCENE
	
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
	
	if not "Normal" in anim_name :
		$CurrentScene.add_child(next_scene)
		assert(next_scene.connect("SignalSceneChanging", self, "handle_scene_changing")==0, "ERR:SceneManager/animation_finished> Scene manager failed to connect to 'SignalSceneChanging' from '%s%%'" % next_scene.filename)
		print('transition animation middle point')
		next_scene.load_scene(current_scene.scene_parameters)  
		next_scene.visible = true
		current_scene.queue_free()
		current_scene = next_scene
		#current_scene.load_saved_informations()
		if screen_loaded == ScreenLoaded.JUST_MENU:
			$menu.visible = true
			var player = Utils.get_player()
			player.set_control(false)
			$Menu/NinePatchRect/VBoxContainer/Biomons.grab_focus()
		next_scene = null
		$ScreenTransition/AnimationPlayer.play(next_animation_name)

func saving_game_data():
	var saved_dictionary = {
		"current_scene": current_scene.filename,
		"scene_parameters": current_scene.get_scene_parameters(),
		"minutes_played": $GameTimer.get_minutes_played()
	}
	return saved_dictionary

func loading_game_data(game_dictionnary):
	next_scene = game_dictionnary.current_scene
	current_scene.scene_parameters = game_dictionnary.scene_parameters
	$GameTimer.set_minutes_played(game_dictionnary.minutes_played)

func get_current_scene_name():
	return current_scene.location
