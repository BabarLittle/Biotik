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
extends TextureButton

# Set up signals
signal SignalButtonPressed # mandatory for the scene manager to work properly

# Set up variables
export var id_button: String # Signal wich button is being pressed
export var text_button: String = "Button" # Text of the button
export var exit_button: bool = false # change the color of the button
export var first_button: bool = false

"""=====
Function _ready():
Author: Ska
	Function called when the scene button created. Initialise variables
====="""
func _ready():
	$Label.text = text_button
	
	if first_button:
		grab_focus()
	
	if exit_button:
		texture_normal = load("res://assets/ui/interface/button-r2.png")
		texture_focused = load("res://assets/ui/interface/button-r1.png")
		texture_pressed = load("res://assets/ui/interface/button-r1.png")
	
	assert(connect("SignalButtonPressed", get_parent(), "button_pressed") == 0, "ERR:biodex_infos/_ready> Signal 'SignalButtonPressed' couild not connect to '%s%%'" % get_parent().name)
	
"""=====
Function _on_ButtonUI_pressed():
Author: Ska
	Function called when the scene button is pressed. Emit signal with argument.
====="""
func _on_ButtonUI_pressed():
	emit_signal("SignalButtonPressed", id_button)
