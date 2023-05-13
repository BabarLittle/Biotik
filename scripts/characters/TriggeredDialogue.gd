extends NinePatchRect

const TEXT_LABEL_PATH = "Margin/VBoxContainer/DialogueText"
const TRIGGER_TEXTURE_PATH = "Margin/TriggerTexture"
const SIZE_DIALOGUE = Vector2(32, 16)
const SIZE_TRIGGER = Vector2(16, 16)

var text_to_write
var current_char = 0
var text_label
var trigger_texture
var prompter

onready var player = Utils.get_player()
onready var base_position = rect_position

func _ready():
	set_as_toplevel(true)
	prompter = get_node("Prompter")
	visible = false
	trigger_texture = get_node(TRIGGER_TEXTURE_PATH)
	trigger_texture.visible = false
	text_label = get_node(TEXT_LABEL_PATH)	
	text_label.text = ""
	

func _physics_process(_delta):
	rect_position = get_parent().position + base_position

func write_dialogue(text=""):
	if typeof(text) != TYPE_STRING:
		return
	if text == "":
		return
	
	text_label.text = ""
	visible = true
	text_to_write = text
	current_char = 0
	set_text_speed()
	
	dialogue_prompter()
	
func dialogue_prompter():
	if current_char < text_to_write.length():
		text_label.text += text_to_write[current_char]
		current_char += 1
		prompter.start()
	else:
		return
		
func reset_dialogue():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(1,1,1,0), 0.5).from(modulate)
	
func set_text_speed(new_value=SettingsManager.get_text_speed()):
	prompter.wait_time = new_value
	
func trigger_event():
	player.set_control(false)
	text_label.visible = false
	trigger_texture.visible = true
	modulate = Color(1,1,1,1)
	rect_size = SIZE_TRIGGER

func free_event(player_control=false, player_direction=player.last_known_direction):
	player.set_control(player_control)
	player.set_spawn(player.position, player_direction)
	text_label.visible = true
	trigger_texture.visible = false
	modulate = Color(1,1,1,0)
	rect_size = SIZE_DIALOGUE
	
