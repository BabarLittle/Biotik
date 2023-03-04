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
enum ScreenLoaded { NOTHING, JUST_MENU, MENU_SCREENS, DIALOGUE }

# Set variables
var screen_loaded = ScreenLoaded.NOTHING
var current_scene = "" 
onready var menu =$NinePatchRect


# old
const BiomonPartyScreen = preload("res://scenes/UI/Screen/PartyScreen.tscn")
const BiodexScreen = preload("res://scenes/UI/Screen/biodex.tscn")
var selected_option: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	menu.visible = false
	connect("SignalSceneChanging", Utils.get_scene_manager(), "handle_scene_changing")
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
	""" hide the menu scene """
	menu.visible = false
	
	""" stores the current map the player is on """
	current_scene = Utils.get_current_scene()
	
	""" switch the enum so we know were we're standing """	
	screen_loaded = ScreenLoaded.MENU_SCREENS
	
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
	menu.visible = true
	screen_loaded = ScreenLoaded.JUST_MENU
	emit_signal("SignalSceneChanging", current_scene, "FadeToBlack")

func _unhandled_input(event):
	match screen_loaded:
		ScreenLoaded.NOTHING:
			if event.is_action_pressed("menu"):
				var player = Utils.get_player()
				if !player.is_moving:
					player.set_physics_process(false)
					menu.visible = true
					$NinePatchRect/VBoxContainer/Biomons.grab_focus()
				screen_loaded = ScreenLoaded.JUST_MENU
		ScreenLoaded.JUST_MENU:
			var player = Utils.get_player()
			if event.is_action_pressed("menu"):
				player.set_physics_process(true)
				menu.visible = false
				screen_loaded = ScreenLoaded.NOTHING
		ScreenLoaded.DIALOGUE:
			menu.visible = false







""" old """
# Called when the node enters the scene tree for the first time.
"""func _ready():
	menu.visible = false"""
	
func load_party_screen():
	menu.visible = false
	screen_loaded = ScreenLoaded.MENU_SCREENS
	var party_screen = BiomonPartyScreen.instance()
	add_child(party_screen)
	
func unload__party_screen():
	menu.visible = true
	remove_child($BiomonPartyScreen)
	screen_loaded = ScreenLoaded.JUST_MENU

""" Added 2 functions to try and dynamise the script a little bit 
func load_screen(new_screen="", method="", param1=0):
	menu.visible = false
	next_screen = new_screen.instance()
	screen_loaded = ScreenLoaded.MENU_SCREENS
	#current_screen = next_screen	
	add_child(next_screen)
	# gives a function and an argument if existant
	if next_screen.has_method(method):
		next_screen.call(method, param1)

func unload_screen():
	menu.visible = true
	screen_loaded = ScreenLoaded.JUST_MENU
	remove_child(next_screen)
	
 ======== """


			
"""			
func _on_Biomon_pressed():
	print('Biomon pressed')


func _on_Inventory_pressed():
	print("Inventory pressed")

func _on_Biodex_pressed():
	print("Biodex pressed")
	#load_screen(BiodexScreen)

func _on_Character_pressed():
	print("Character pressed")

func _on_Option_pressed():
	print("Option pressed")

func _on_Save_pressed():
	print("Save pressed")

func _on_Leave_pressed():
	get_tree().quit()			
			
"""
