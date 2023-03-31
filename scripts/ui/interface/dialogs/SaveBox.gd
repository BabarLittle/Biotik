extends CanvasLayer

export(String, FILE, "*.json") var dialog_file

var dialogue = []
var current_dialogue_id = 0

var d_active = false
var pop_up_active = false

var menu
var scene_manager


func _ready():
	$NinePatchRect.visible = false
	menu = Utils.get_menu()
	scene_manager = Utils.get_scene_manager()
	

func start():
	d_active = true
	visible = true
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
	if pop_up_active:
		return
	elif event.is_action_pressed('ui_accept'):
		next_script()
		
func next_script():
	current_dialogue_id +=1
	
	if current_dialogue_id >= len(dialogue):
		$Timer.start()
		$NinePatchRect.visible = false
		Utils.get_menu().visible = false
		scene_manager.screen_loaded = scene_manager.ScreenLoaded.SCENE
		return
		
	if dialogue[current_dialogue_id]["name"] == "ChoiceBox":
		pop_up_active = true
		$ChoiceBox.load_choice_box(dialogue[current_dialogue_id].text)
		return
	
	$NinePatchRect/Name.text = dialogue[current_dialogue_id]["name"]
	$NinePatchRect/Text.text = dialogue[current_dialogue_id]["text"]

func choice_box_return(result):
	if result == "true":
		SaveManager.save_game()
	pop_up_active = false
	$ChoiceBox.visible = false
	
func _on_Timer_timeout():
	d_active = false
