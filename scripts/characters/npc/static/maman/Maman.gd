extends KinematicBody2D

onready var name_text = get_node("LbName")
onready var action_text = get_node("LbAction")

# Called when the node enters the scene tree for the first time.
func _ready():
	name_text.visible = false
	action_text.visible = false

