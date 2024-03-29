extends CanvasLayer

const BASE_SIZE = Vector2(12,12)
const CHAR_ESTIMATE_LENGTH = 9
const CHOICE_HEIGHT = 16
const MARGIN_BOTTOM = 38
const MARGIN_TOP = MARGIN_BOTTOM-6
const MARGIN_LEFT = -30
const MARGIN_RIGHT = -4

var dialogue_manager
#onready var choice_container = get_node("$MarginContainer/NinePatchRect/VBoxContainer")
var choice_ready = false
var button_array = []
var BUTTON_SCENE_PATH = "res://scenes/ui/interface/dialogs/ButtonChoice.tscn"


func _ready():
	self.visible = false
	dialogue_manager = Utils.get_dialogue_manager()

func start_choice(choice_array):
	var longest_button_size = 0
	
	for i in button_array.size():
		button_array[i].queue_free()
		
	button_array = []
	
	for i in range(1, choice_array.size()):
		create_button(choice_array[i])
		if button_array[i-1].get_size() > longest_button_size:
			longest_button_size = button_array[i-1].get_size()
	
	resize_choice_box(longest_button_size)
	

func create_button(button_data):
	var new_button_prepare = load(BUTTON_SCENE_PATH)
	var first_button = false
	var temp_id = button_array.size()
	button_array.append(new_button_prepare.instance())
	$MarginContainer/NinePatchRect/ChoiceContainer.add_child(button_array[temp_id])
	if button_array.size() == 1:
		first_button = true
	button_array[temp_id].connect("SignalChoiceButtonPressed", self, "selecting_choice")
	button_array[temp_id].load_button(button_data.text, first_button, button_data.return)
	
func resize_choice_box(longest_button_size):
	$MarginContainer.margin_bottom = MARGIN_BOTTOM
	$MarginContainer.margin_right = MARGIN_RIGHT
	$MarginContainer.margin_left = MARGIN_LEFT-longest_button_size
	$MarginContainer.margin_top = MARGIN_TOP-(button_array.size()*CHOICE_HEIGHT)
	
func selecting_choice(feedback):
	dialogue_manager.dialogue_feedback(feedback)
	self.visible = false
