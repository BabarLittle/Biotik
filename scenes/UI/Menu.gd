extends Node


onready var menu =$NinePatchRect

const BiomonPartyScreen = preload("res://scenes/UI/Screen/PartyScreen.tscn")
const BiodexScreen = preload("res://scenes/UI/Screen/biodex.tscn")
var next_screen
var current_screen

enum ScreenLoaded { NOTHING, JUST_MENU, MENU_SCREENS, DIALOGUE }
var screen_loaded = ScreenLoaded.NOTHING


var selected_option : int = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	menu.visible = false
	
func load_party_screen():
	menu.visible = false
	screen_loaded = ScreenLoaded.MENU_SCREENS
	var party_screen = BiomonPartyScreen.instance()
	add_child(party_screen)
	
func unload__party_screen():
	menu.visible = true
	remove_child($BiomonPartyScreen)
	screen_loaded = ScreenLoaded.JUST_MENU

""" Added 2 functions to try and dynamise the script a little bit """
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
	
""" ======== """

func _unhandled_input(event):
	var player = Utils.get_player()
	match screen_loaded:
		ScreenLoaded.NOTHING:
			if event.is_action_pressed("menu"):
				if !player.is_moving:
					player.set_physics_process(false)
					menu.visible = true
					$NinePatchRect/VBoxContainer/Biomon.grab_focus()
				screen_loaded = ScreenLoaded.JUST_MENU
		ScreenLoaded.JUST_MENU:
			if event.is_action_pressed("menu"):
				player.set_physics_process(true)
				menu.visible = false
				screen_loaded = ScreenLoaded.NOTHING
		ScreenLoaded.DIALOGUE:
			menu.visible = false
				
func _on_Biomon_pressed():
	print('Biomon pressed')
	

func _on_Inventory_pressed():
	print("Inventory pressed")

func _on_Biodex_pressed():
	load_screen(BiodexScreen)

func _on_Character_pressed():
	print("Character pressed")
	

func _on_Option_pressed():
	print("Option pressed")
	


func _on_Save_pressed():
	print("Save pressed")



func _on_Leave_pressed():
	get_tree().quit()
