extends ClassScreen

# Set up signals

# Set up constants
const TRAVELLING_SPEED = 0.4
const MAIN_TITLE_PATH = "res://scenes/debug/DebugMain.tscn"

# Set up variables


func _load_screen():
	load_saved_informations()
	
func _pack_scene():
	pass

func load_saved_informations():
	print(SaveManager.get_saved_informations().keys())
	for child in $Control.get_children():
			child.set_button_informations(SaveManager.get_saved_informations()[child.name])
	
func load_selected_game(game_id):
	SaveManager.loading_game("game"+str(game_id))
	
func _input(event):
	if event.is_action_pressed("menu") or event.is_action_pressed("cancel"):
		$AudioStreamPlayer.stream = load("res://assets/audio/sfx/029_Decline_09.wav")
		$AudioStreamPlayer.play()
		exit_scene(MAIN_TITLE_PATH)
