extends Area2D

export (int) var full_value_distance = 50 
var floating_dialogue
var player_name
var dialogue_active = false
var dialogue_enabled = true

func _ready():
	floating_dialogue = get_parent().get_node("TriggeredDialogue")
	player_name = Utils.get_player().name

func _physics_process(_delta):
	if dialogue_active:
		if Utils.get_player() != null:
			var alpha_value = full_value_distance / get_parent().position.distance_to(Utils.get_player().position)
			if alpha_value > 1:
				alpha_value = 1
			floating_dialogue.modulate = Color(1, 1, 1, alpha_value)

func _on_DialogueDetection_body_entered(body):
	if body.name == player_name and !dialogue_active:
		floating_dialogue.write_dialogue(get_parent().floating_text)
		dialogue_active = true


func _on_DialogueDetection_body_exited(body):
	if body.name == player_name and dialogue_active:
		floating_dialogue.reset_dialogue()
		dialogue_active = false

func set_state(state):
	dialogue_enabled = state
