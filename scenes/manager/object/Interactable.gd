extends Area2D

signal interact

var partner
var interact = false






# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Interactable_area_entered(area):
	if area.get_parent().name == "Player":
		get_parent().get_node("Parler").visible = true
		partner = area.get_parent().name
		interact = true

func _on_Interactable_area_exited(area):
	if area.get_parent().name == 'Player' and get_parent().is_in_group('NPCs') :
		get_parent().get_node("Parler").visible = false
		interact = false

func _input(event):
	if interact:
		if event.is_action_pressed("interact"):
			use_dialogue()
			
func use_dialogue():
	var dialogue = get_parent().get_node("DialogueBox")
	
	if dialogue:
		dialogue.start()



