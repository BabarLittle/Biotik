extends ClassScreen

enum Slot_number { FIRST, SECOND, THIRD, FOURTH, FIFTH, SIXTH }
var selected_option: int = Slot_number.FIRST

onready var slot: Dictionary = {
	Slot_number.FIRST : $FirstSlot/Background
}

func unset_active_slot():
	slot[selected_option]. frame = 0
	
func set_active_slot():
	slot[selected_option] = 1

func _ready():
	pass

func _unhandled_input(event):
	if event.is_action_pressed("cancel"):
		exit_scene("menu")
