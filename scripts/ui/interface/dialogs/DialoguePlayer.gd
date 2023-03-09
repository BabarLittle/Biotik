<<<<<<< Updated upstream:scenes/UI/interface/dialogue/DialoguePlayer.gd
=======
"""=======================================
File: DialoguePlayer.gd
Author: Babar
Version: 0.2 
Description:
	manage dialogues
Changes:
	0.1 (Babar)
		- File Created 
	0.2 (Ska)
		- Updating script to fit new scene manager
To-do: (--)
======================================="""

>>>>>>> Stashed changes:scripts/ui/interface/dialogs/DialoguePlayer.gd
extends CanvasLayer

export(String, FILE, "*.json") var dialog_file

var dialogue = []
var current_dialogue_id = 0

var d_active = false


var player
var menu
var scene_manager


func _ready():
	$NinePatchRect.visible = false
	player = Utils.get_player()
	menu = Utils.get_menu()
	scene_manager = Utils.get_scene_manager()
	
	
func start():
	if d_active or !scene_manager.screen_loaded == scene_manager.ScreenLoaded.SCENE:
		return
	player.set_physics_process(false)
	scene_manager.screen_loaded = scene_manager.ScreenLoaded.DIALOGUE
	d_active = true
	$NinePatchRect.visible = true
	dialogue = load_dialogue()
	current_dialogue_id = -1
	next_script()

	
func load_dialogue():
	var file = File.new()
	if file.file_exists(dialog_file):
		file.open(dialog_file, file.READ)
		return parse_json(file.get_as_text())

func _input(event):
	if not d_active:
		return
	if event.is_action_pressed('ui_accept'):
		next_script()
		
func next_script():
	current_dialogue_id +=1
	
	if current_dialogue_id >= len(dialogue):
		$Timer.start()
		$NinePatchRect.visible = false
		player.set_physics_process(true)
		scene_manager.screen_loaded = scene_manager.ScreenLoaded.SCENE
		return
	
	$NinePatchRect/Name.text = dialogue[current_dialogue_id]["name"]
	$NinePatchRect/Text.text = dialogue[current_dialogue_id]["text"]

func _on_Timer_timeout():
	d_active = false
