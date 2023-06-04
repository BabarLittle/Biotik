# meta-name: Annoted menu screen
# meta-description: Base template with complete annoted code for screen generation in Biotik
"""=============================================
File: biodex_infos.gd
Author: Ska
Version: 0.2
Description:
	Controls and show the biodex 
	The sprites are controlled on this Script
	The names follow a signal and control themselves

Changes: 
	0.1 (Ska)
		- file creation
	0.2.2023.03.05 (Ska)
		- Updating the script with annotation and correct functions / signals to work with the 
		new scene manager and the new menu scene.
		- Is now a child of biodex_infos. Both scenes works together.

To-do: 
	- Eventually optimize both list scripts so we can move both with the same call and in the same way
	- Clean the code to take the biodex_infos inclusion into consideration
	- Switching between screens animations
============================================="""
extends ClassScreen

var current_id = 1
var new_id = 1
var transition_id = 1
var biodex_scene = "res://scenes/ui/screens/biodex/Biodex.tscn"
var map_scene = "res://scenes/ui/screens/maps/WorldMap.tscn"

func _load_screen():
	if "last_biomon_id" in scene_parameters.keys():
		current_id = scene_parameters.last_biomon_id
	load_biomon(current_id)
	
func _pack_scene():
	scene_parameters.last_biomon_id = current_id

""" User input """
func _unhandled_input(event):		
		""" Biomon id changer """
		if event.is_action_pressed("ui_up"):
			new_id = DataRead.next_id(current_id, -1, "biodex")
			load_biomon(new_id)
		elif event.is_action_pressed("ui_down"):
			new_id = DataRead.next_id(current_id, 1, "biodex")
			load_biomon(new_id)

""" Load biomon data into the scene """
func load_biomon(id=1):
	current_id = id
	$BiomonSprite.select_sprite(id)
	$Id.text = str(id)
	$Name.text = DataRead.database.biodex[str(id)].name
	$Height.text = str(float(DataRead.database.biodex[str(id)].h) / 100)
	$Weight.text = str(DataRead.database.biodex[str(id)].w)
	$Species.text = DataRead.database.biodex[str(id)].species
	$Desc.text = DataRead.database.biodex[str(id)].desc
	$TypeSprite.load_type(DataRead.database.biodex[str(id)].type1)
	$TypeSprite2.load_type(DataRead.database.biodex[str(id)].type2)
	
	# Create stat dictionnary
	var stats_dictionnary = DataRead.get_base_stats_dictionary(id)
	$Stats.load_biomon_stats(stats_dictionnary, true)
	
"""=====
Function button_pressed():
Author: Ska
	Handle button pressed signals
	
Arguments:
	-id_button: text id of the pressed button
====="""
func button_pressed(id_button):
	match id_button:
		"zone":
			exit_scene(map_scene)
		"exit":
			exit_scene(biodex_scene)
		"stats":
			if $Stats.visible:
				$Stats.visible = false
			else:
				$Stats.visible = true
		"cri":
			print("cri")
