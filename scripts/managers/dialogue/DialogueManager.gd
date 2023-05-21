extends CanvasLayer

signal SignalDialogueFeedback

const DIALOG_DATA_PATH = "res://data/dialogues/"

var player = null
var dialogue_sponsor
var dialogue_active = false
var target_func = ""

func _ready():
	set_visible(false)
	dialogue_active = false

func submit_dialogue(sponsor, dialogue_key, target_feedback="dialogue_feedback"):
	if dialogue_active:
		return
	
	dialogue_active = true
	
	target_func = target_feedback
	dialogue_sponsor = sponsor
	assert(connect("SignalDialogueFeedback", dialogue_sponsor, target_func) == 0, "Error, couldnt connect to target '" + dialogue_sponsor.filename + '"')
	player = Utils.get_player()
	player.set_control(false)
	load_dialogue(dialogue_key)
	
func dialogue_feedback(feedback="end"):
	emit_signal("SignalDialogueFeedback", feedback)
	set_visible(false, "choice")

func load_dialogue(json_file):
	json_file = DIALOG_DATA_PATH + json_file + ".json"
	print(json_file)
	var file = File.new()
	
	if !file.file_exists(json_file):
		print("JSON file not existing at path '" + json_file + "'")
		close_dialogue()
		return
	
	file.open(json_file, file.READ)
	var json_string = file.get_as_text()
	file.close()
	var temp_json = JSON.parse(json_string)
	var dialogue_array = temp_json.result
	
	if !typeof(dialogue_array) == TYPE_ARRAY:
		print("Unexpected data, dialogue closed")
		close_dialogue()
		return
	
	if !"type" in dialogue_array[0]:
		print("No dialogue type provided, dialogue closed")
		close_dialogue()
		return
	
	match dialogue_array[0].type:
		"text":
			set_visible(true, "self_text")
			$TextBox.start_dialogue(dialogue_array)
		"choice":
			set_visible(true, "self_choice")
			$ChoiceBox.start_choice(dialogue_array)

func close_dialogue():
	disconnect("SignalDialogueFeedback", dialogue_sponsor, target_func)
	dialogue_active = false
	player.set_control(true)
	set_visible(false)

func set_visible(value=false, what="self_text_choice"):
	if "text" in what:
		$TextBox.visible = value
	if "choice" in what:
		$ChoiceBox.visible = value
	if "self" in what:
		visible = value
