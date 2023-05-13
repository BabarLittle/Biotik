# meta-name: Annoted biotik scene
# meta-description: Base template with complete annoted code for scene generation in Biotik
"""=============================================
File: Menu.gd
Author: Babar
Version: 0.2
Description:
	In game menu. Loads at launch and stay invisible. The different menu screens are independant
	scenes that manages themselves. The menu is just here to tell the scene manager wich one to 
	launch.

Changes: 
	0.1 (Babar)
		- file creation
	0.2.2023.3.4 (Ska)
		- File annoted
		- Updating the script and scene to works with new scene manager
		- Adding transition "FadeToWhite" and "FadeWhiteToNormal"

To-do: 
	- add exception and confirmation when trying to quit

============================================="""

extends Node

# Set signal
signal SignalSceneChanging

# Set constants and enums
enum ScreenLoaded {SCENE, MENU_SCREEN, BATTLE_SCREEN, TITLE_SCREEN, JUST_MENU, DIALOGUE}

# Set variables
var current_scene_path = "" 
onready var menu =$NinePatchRect


# Called when the node enters the scene tree for the first time.
func _ready():
	menu.visible = false
	assert(connect("SignalSceneChanging", Utils.get_scene_manager(), "handle_scene_changing") == 0, "'Menu failed to connect 'SignalSceneChanging' to SceneManager")
	for i in $NinePatchRect/VBoxContainer.get_children():
		i.connect("SignalMenuButtonPressed", self, "load_screen")

"""=====
Function load_screen()
Author: Ska
	Basically interpret the SignalButtonPressed and act accordingly. Mostly pass information to 
	SceneManager.handle_level_changing() through "SignalSceneChanging"
	
Arguments:
	- next_screen_name: String passed by the current scene to determines wich scene is the next
====="""
func load_screen(next_screen_name:String=""):	
	print("Menu recieived next_screen name : '" + next_screen_name + "'")
	if Utils.get_scene_manager().screen_loaded == ScreenLoaded.DIALOGUE:
		print("Currently dialoguing... Blocking the menu")
		return
	if next_screen_name == "menu":
		unload_screen()
	elif next_screen_name == "quit":
		get_tree().quit()
	elif next_screen_name == "saving":
		Utils.get_scene_manager().screen_loaded = ScreenLoaded.DIALOGUE
		Utils.get_dialogue_manager().submit_dialogue(self, "save")
	else:
		""" hide the menu scene """
		menu.visible = false
		
		""" switch the enum so we know were we're standing """	
		Utils.get_scene_manager().screen_loaded = ScreenLoaded.MENU_SCREEN
		
		""" emit signal to SceneManager """
		emit_signal("SignalSceneChanging", next_screen_name, "FadeToWhite")

"""=====
Function unload_screen()
Author: Ska
	Return to current_scene through "SignalSceneChanging"
	
Arguments:
	- next_screen_name: String passed by the current scene to determines wich scene is the next
====="""
func unload_screen():
	Utils.get_scene_manager().screen_loaded = ScreenLoaded.JUST_MENU
	Utils.get_current_scene().exit_scene(current_scene_path)
	
func _unhandled_input(event):
	match Utils.get_scene_manager().screen_loaded:
		ScreenLoaded.SCENE:
			if event.is_action_pressed("menu"):
				""" stores the current map the player is on """
				current_scene_path = Utils.get_current_scene().filename
				print(current_scene_path)
				var player = Utils.get_player()
				if !player.is_moving:
					player.set_control(false)
					menu.visible = true
					$NinePatchRect/VBoxContainer/Biomons.grab_focus()
				Utils.get_scene_manager().screen_loaded = ScreenLoaded.JUST_MENU
		ScreenLoaded.JUST_MENU:
			if event.is_action_pressed("menu") or event.is_action_pressed("cancel"):
				close_menu()
		ScreenLoaded.MENU_SCREEN:
			if event.is_action_pressed("menu"):
				print("Escaping directly to menu")
				unload_screen()
		ScreenLoaded.DIALOGUE:
			menu.visible = false

func dialogue_feedback(feedback=""):
	if feedback == "true":
		SaveManager.save_game()
		Utils.get_dialogue_manager().load_dialogue("saving")
	elif feedback == "false":
		Utils.get_dialogue_manager().load_dialogue("saveCancel")
	elif feedback == "end":
		close_menu()

func close_menu():
	var player = Utils.get_player()
	player.set_control(true)
	menu.visible = false
	Utils.get_scene_manager().screen_loaded = ScreenLoaded.SCENE
