tool
# meta-name: Annoted biotik
# meta-description: Base template with complete annoted code for scene generation in Biotik
"""=============================================
File: dex_button.gd
Author: Ska
Version: 0.1
Description:
	Base scene for ui button

Changes: 
	0.1 (Ska)
		- file creation
============================================="""
extends Button

# Set up signals
signal SignalButtonPressed

# Set up variables
export(String, FILE) var id_button # Signal wich button is being pressed
export(String) var text_button = "empty" setget set_text # Text of the button
export(Vector2) var PlayerPosition
export(Vector2) var PlayerDirection
export var exit_button: bool = false # change the color of the button
export var first_button: bool = false

"""=====
Function _ready():
Author: Ska
	Function called when the scene button created. Initialise variables
====="""
func _ready():
	text = text_button
	$AudioStreamPlayer.volume_db = -80
	if first_button:
		grab_focus()
	var temp_parent = get_parent().get_parent().get_parent().get_parent()
	assert(connect("SignalButtonPressed", temp_parent, "button_pressed") == 0, "ERR:biodex_infos/_ready> Signal 'SignalButtonPressed' couild not connect to '%s%%'" % get_parent().name)
	$AudioStreamPlayer.volume_db = -20
	
"""=====
Function _on_ButtonUI_pressed():
Author: Ska
	Function called when the scene button is pressed. Emit signal with argument.
====="""
func _on_ButtonUI_pressed():
	emit_signal("SignalButtonPressed", id_button, PlayerPosition, PlayerDirection)
	$AudioStreamPlayer.stream = load("res://assets/audio/sfx/013_Confirm_03.wav")
	$AudioStreamPlayer.play()

func _on_ButtonUI_focus_entered():
	if !first_button:
		$AudioStreamPlayer.stream = load("res://assets/audio/sfx/001_Hover_01.wav")
		$AudioStreamPlayer.play()
	else:
		first_button = false

func set_text(value):
	text = value
	text_button = value
