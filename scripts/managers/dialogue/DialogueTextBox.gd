extends CanvasLayer

const TITLE_LABEL_PATH = "MarginContainer/NinePatchRect/Title/TextTitle"
const TEST_LABEL_PATH = "MarginContainer/NinePatchRect/MainText/Text"

var current_line = 0
var line_ready = false
var current_char = 0
var dialogue_array = []
var title_label
var text_label
var prompter
var waiting_next = false

func _ready():
	title_label = get_node(TITLE_LABEL_PATH)
	text_label = get_node(TEST_LABEL_PATH)
	prompter = $Prompter
	waiting_next = false
	line_ready = false

func start_dialogue(array):
	current_line = 0
	current_char = 0
	dialogue_array = array
	waiting_next = false
	line_ready = false
	set_text_speed()
	read_next_line()
	
func read_next_line():
	line_ready = false
	
	if waiting_next:
		return
	
	current_line += 1
	
	if dialogue_array[current_line].type == "end":
		Utils.get_dialogue_manager().dialogue_feedback()
		Utils.get_dialogue_manager().close_dialogue()
		return

	current_char = 0
	text_label.text = ""
	
	if "title" in dialogue_array[current_line].keys():
		title_label.text = dialogue_array[current_line].title
	
	if dialogue_array[current_line].type == "choice":
		waiting_next = true
		Utils.get_dialogue_manager().load_dialogue(dialogue_array[current_line].target)
	
	dialogue_prompter()
	
func dialogue_prompter():
	if current_char < dialogue_array[current_line].text.length():
		text_label.text += dialogue_array[current_line].text[current_char]
		current_char += 1
		prompter.start()
	else:
		line_ready = true

func _unhandled_input(event):
	if line_ready and event.is_action_pressed("ui_accept"):
		read_next_line()

func set_text_speed(new_value=SettingsManager.get_text_speed()):
	prompter.wait_time = new_value
